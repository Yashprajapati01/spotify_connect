import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/generated_playlist.dart';
import '../../../domain/entities/enhanced_playlist.dart';
import '../../../domain/usecases/analyze_user_taste.dart';
import '../../../domain/usecases/generate_enhanced_playlist.dart';
import '../../../domain/usecases/create_playlist.dart';
import '../../../domain/usecases/get_user_playlist.dart';
import '../../../data/services/taste_profile_cache_service.dart';
import 'explore_mode_event.dart';
import 'explore_mode_state.dart';

@injectable
class ExploreModeBloc extends Bloc<ExploreModeEvent, ExploreModeState> {
  final AnalyzeUserTaste _analyzeUserTaste;
  final GenerateEnhancedPlaylist _generateEnhancedPlaylist;
  final CreateSpotifyPlaylist _createSpotifyPlaylist;
  final GetUserPlaylists _getUserPlaylists;
  final TasteProfileCacheService _cacheService;

  ExploreModeBloc(
    this._analyzeUserTaste,
    this._generateEnhancedPlaylist,
    this._createSpotifyPlaylist,
    this._getUserPlaylists,
    this._cacheService,
  ) : super(const ExploreModeInitial()) {
    on<AnalyzeUserTasteEvent>(_onAnalyzeUserTaste);
    on<GenerateEnhancedPlaylistEvent>(_onGenerateEnhancedPlaylist);
    on<SaveEnhancedPlaylistEvent>(_onSaveEnhancedPlaylist);
    on<ResetExploreModeEvent>(_onResetExploreMode);
  }

  Future<void> _onAnalyzeUserTaste(
    AnalyzeUserTasteEvent event,
    Emitter<ExploreModeState> emit,
  ) async {
    try {
      // Check if we should force refresh or use cache
      final forceRefresh = event.forceRefresh ?? false;

      if (!forceRefresh) {
        // Try to get cached profile first
        final cachedProfile = await _cacheService.getCachedProfile();
        if (cachedProfile != null) {
          emit(TasteAnalysisComplete(cachedProfile));
          return;
        }
      }

      emit(const ExploreModeLoading('Analyzing your music taste...'));

      // Get user playlists
      final playlists = await _getUserPlaylists();

      // Analyze taste profile
      final tasteProfile = await _analyzeUserTaste(playlists);

      // Cache the new profile
      await _cacheService.cacheProfile(tasteProfile);

      emit(TasteAnalysisComplete(tasteProfile));
    } catch (e) {
      emit(ExploreModeError('Failed to analyze your taste: ${e.toString()}'));
    }
  }

  Future<void> _onGenerateEnhancedPlaylist(
    GenerateEnhancedPlaylistEvent event,
    Emitter<ExploreModeState> emit,
  ) async {
    try {
      emit(const ExploreModeLoading('Creating your enhanced playlist...'));

      // Get current taste profile or analyze if not available
      late final tasteProfile;
      if (state is TasteAnalysisComplete) {
        tasteProfile = (state as TasteAnalysisComplete).tasteProfile;
      } else {
        final playlists = await _getUserPlaylists();
        tasteProfile = await _analyzeUserTaste(playlists);
      }

      // Generate enhanced playlist
      final enhancedPlaylist = await _generateEnhancedPlaylist(
        event.request,
        tasteProfile,
      );

      emit(EnhancedPlaylistGenerated(enhancedPlaylist, tasteProfile));
    } catch (e) {
      emit(ExploreModeError('Failed to generate playlist: ${e.toString()}'));
    }
  }

  Future<void> _onSaveEnhancedPlaylist(
    SaveEnhancedPlaylistEvent event,
    Emitter<ExploreModeState> emit,
  ) async {
    try {
      if (state is! EnhancedPlaylistGenerated) return;

      final currentState = state as EnhancedPlaylistGenerated;
      emit(
        EnhancedPlaylistSaving(
          currentState.playlist,
          currentState.tasteProfile,
        ),
      );

      // Convert to GeneratedPlaylist format for saving
      final generatedPlaylist = _convertToGeneratedPlaylist(
        currentState.playlist,
      );

      // Save to Spotify
      await _createSpotifyPlaylist(generatedPlaylist);

      emit(
        EnhancedPlaylistSaved(
          currentState.playlist,
          currentState.tasteProfile,
          currentState.playlist.id,
        ),
      );
    } catch (e) {
      emit(ExploreModeError('Failed to save playlist: ${e.toString()}'));
    }
  }

  Future<void> _onResetExploreMode(
    ResetExploreModeEvent event,
    Emitter<ExploreModeState> emit,
  ) async {
    emit(const ExploreModeInitial());
  }

  GeneratedPlaylist _convertToGeneratedPlaylist(
    EnhancedPlaylist enhancedPlaylist,
  ) {
    return GeneratedPlaylist(
      id: enhancedPlaylist.id,
      name: enhancedPlaylist.name,
      description: enhancedPlaylist.description,
      mood: enhancedPlaylist.analysisData['mood']?.toString() ?? '',
      tracks: enhancedPlaylist.allTracks,
      sourcePlaylistIds: [], // We don't have this info in EnhancedPlaylist
      createdAt: DateTime.parse(enhancedPlaylist.createdAt),
      isAddedToSpotify: false,
    );
  }
}
