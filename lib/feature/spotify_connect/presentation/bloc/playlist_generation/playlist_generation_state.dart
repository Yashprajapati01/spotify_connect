import 'package:equatable/equatable.dart';

import '../../../domain/entities/generated_playlist.dart';

abstract class PlaylistGenerationState extends Equatable {
  const PlaylistGenerationState();

  @override
  List<Object?> get props => [];
}

class PlaylistGenerationInitial extends PlaylistGenerationState {}

class PlaylistGenerationLoading extends PlaylistGenerationState {}

class PlaylistGenerationSuccess extends PlaylistGenerationState {
  final GeneratedPlaylist generatedPlaylist;

  const PlaylistGenerationSuccess(this.generatedPlaylist);

  @override
  List<Object?> get props => [generatedPlaylist];
}

class PlaylistGenerationError extends PlaylistGenerationState {
  final String message;

  const PlaylistGenerationError(this.message);

  @override
  List<Object?> get props => [message];
}

class PlaylistSaving extends PlaylistGenerationState {
  final GeneratedPlaylist generatedPlaylist;

  const PlaylistSaving(this.generatedPlaylist);

  @override
  List<Object?> get props => [generatedPlaylist];
}

class PlaylistSaved extends PlaylistGenerationState {
  final GeneratedPlaylist generatedPlaylist;

  const PlaylistSaved(this.generatedPlaylist);

  @override
  List<Object?> get props => [generatedPlaylist];
}
