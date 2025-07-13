import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/create_playlist.dart';
import '../../../domain/usecases/generate_mood_playlist.dart';
import 'playlist_generation_event.dart';
import 'playlist_generation_state.dart';

@injectable
class PlaylistGenerationBloc
    extends Bloc<PlaylistGenerationEvent, PlaylistGenerationState> {
  final GenerateMoodPlaylist _generateMoodPlaylist;
  final CreateSpotifyPlaylist _createSpotifyPlaylist;

  PlaylistGenerationBloc(
    this._generateMoodPlaylist,
    this._createSpotifyPlaylist,
  ) : super(PlaylistGenerationInitial()) {
    on<GeneratePlaylist>(_onGeneratePlaylist);
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
}
