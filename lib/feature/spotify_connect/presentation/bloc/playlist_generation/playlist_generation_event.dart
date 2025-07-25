//
// @immutable
// sealed class PlaylistGenerationEvent {}
import 'package:equatable/equatable.dart';

abstract class PlaylistGenerationEvent extends Equatable {
  const PlaylistGenerationEvent();

  @override
  List<Object> get props => [];
}

class GeneratePlaylist extends PlaylistGenerationEvent {
  final List<String> selectedPlaylistIds;
  final String mood;

  const GeneratePlaylist({
    required this.selectedPlaylistIds,
    required this.mood,
  });

  @override
  List<Object> get props => [selectedPlaylistIds, mood];
}

class SaveGeneratedPlaylist extends PlaylistGenerationEvent {
  final String playlistId;

  const SaveGeneratedPlaylist(this.playlistId);

  @override
  List<Object> get props => [playlistId];
}

class ClearGeneratedPlaylist extends PlaylistGenerationEvent {}
