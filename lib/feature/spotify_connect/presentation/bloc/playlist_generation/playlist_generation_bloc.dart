import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/create_playlist.dart';
import '../../../domain/usecases/generate_mood_playlist.dart';
import '../../../domain/usecases/analyze_user_taste.dart';
import '../../../domain/usecases/generate_enhanced_playlist.dart';
import '../../../domain/usecases/get_user_playlist.dart';
import '../../../domain/entities/explore_mode_request.dart';
import '../../../domain/entities/enhanced_playlist.dart';
import '../../../domain/entities/generated_playlist.dart';
import 'playlist_generation_event.dart';
import 'playlist_generation_state.dart';

@injectable
class PlaylistGenerationBloc
    extends Bloc<PlaylistGenerationEvent, PlaylistGenerationState> {
  final GenerateMoodPlaylist _generateMoodPlaylist;
  final CreateSpotifyPlaylist _createSpotifyPlaylist;
  final AnalyzeUserTaste _analyzeUserTaste;
  final GenerateEnhancedPlaylist _generateEnhancedPlaylist;
  final GetUserPlaylists _getUserPlaylists;

  PlaylistGenerationBloc(
    this._generateMoodPlaylist,
    this._createSpotifyPlaylist,
    this._analyzeUserTaste,
    this._generateEnhancedPlaylist,
    this._getUserPlaylists,
  ) : super(PlaylistGenerationInitial()) {
    on<GeneratePlaylist>(_onGeneratePlaylist);
    on<GenerateEnhancedPlaylistEvent>(_onGenerateEnhancedPlaylist);
    on<SaveGeneratedPlaylist>(_onSaveGeneratedPlaylist);
    on<ClearGeneratedPlaylist>(_onClearGeneratedPlaylist);
  }

  Future<void> _onGeneratePlaylist(
    GeneratePlaylist event,
    Emitter<PlaylistGenerationState> emit,
  ) async {
    emit(PlaylistGenerationLoading());

    try {
      final generatedPlaylist = await _generateMoodPlaylist(
        event.selectedPlaylistIds,
        event.mood,
      );

      emit(PlaylistGenerationSuccess(generatedPlaylist));
    } catch (e) {
      emit(
        PlaylistGenerationError('Failed to generate playlist: ${e.toString()}'),
      );
    }
  }

  Future<void> _onGenerateEnhancedPlaylist(
    GenerateEnhancedPlaylistEvent event,
    Emitter<PlaylistGenerationState> emit,
  ) async {
    emit(PlaylistGenerationLoading());

    try {
      // Get ALL user playlists first
      final allPlaylists = await _getUserPlaylists();

      // Filter to get only selected playlists for taste analysis
      final selectedPlaylists = allPlaylists
          .where((playlist) => event.selectedPlaylistIds.contains(playlist.id))
          .toList();

      // Analyze user taste based ONLY on selected playlists
      final tasteProfile = await _analyzeUserTaste(selectedPlaylists);

      // Create explore mode request
      final exploreRequest = ExploreModeRequest(
        selectedPlaylistIds: event.selectedPlaylistIds,
        mood: event.mood,
        includeNewDiscoveries: event.exploreMode,
        maxTracks: 30,
      );

      // Generate enhanced playlist
      final enhancedPlaylist = await _generateEnhancedPlaylist(
        exploreRequest,
        tasteProfile,
      );

      // Convert to GeneratedPlaylist for compatibility
      final generatedPlaylist = _convertToGeneratedPlaylist(enhancedPlaylist);

      emit(PlaylistGenerationSuccess(generatedPlaylist));
    } catch (e) {
      emit(
        PlaylistGenerationError(
          'Failed to generate enhanced playlist: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onSaveGeneratedPlaylist(
    SaveGeneratedPlaylist event,
    Emitter<PlaylistGenerationState> emit,
  ) async {
    final currentState = state;
    if (currentState is PlaylistGenerationSuccess) {
      emit(PlaylistSaving(currentState.generatedPlaylist));

      try {
        final savedPlaylist = await _createSpotifyPlaylist(
          currentState.generatedPlaylist,
        );
        emit(PlaylistSaved(savedPlaylist));
      } catch (e) {
        emit(
          PlaylistGenerationError('Failed to save playlist: ${e.toString()}'),
        );
      }
    }
  }

  void _onClearGeneratedPlaylist(
    ClearGeneratedPlaylist event,
    Emitter<PlaylistGenerationState> emit,
  ) {
    emit(PlaylistGenerationInitial());
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
