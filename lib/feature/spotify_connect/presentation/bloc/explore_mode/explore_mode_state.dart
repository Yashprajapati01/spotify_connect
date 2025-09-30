import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_taste_profile.dart';
import '../../../domain/entities/enhanced_playlist.dart';

abstract class ExploreModeState extends Equatable {
  const ExploreModeState();

  @override
  List<Object?> get props => [];
}

class ExploreModeInitial extends ExploreModeState {
  const ExploreModeInitial();
}

class ExploreModeLoading extends ExploreModeState {
  final String message;

  const ExploreModeLoading(this.message);

  @override
  List<Object?> get props => [message];
}

class TasteAnalysisComplete extends ExploreModeState {
  final UserTasteProfile tasteProfile;

  const TasteAnalysisComplete(this.tasteProfile);

  @override
  List<Object?> get props => [tasteProfile];
}

class EnhancedPlaylistGenerated extends ExploreModeState {
  final EnhancedPlaylist playlist;
  final UserTasteProfile tasteProfile;

  const EnhancedPlaylistGenerated(this.playlist, this.tasteProfile);

  @override
  List<Object?> get props => [playlist, tasteProfile];
}

class EnhancedPlaylistSaving extends ExploreModeState {
  final EnhancedPlaylist playlist;
  final UserTasteProfile tasteProfile;

  const EnhancedPlaylistSaving(this.playlist, this.tasteProfile);

  @override
  List<Object?> get props => [playlist, tasteProfile];
}

class EnhancedPlaylistSaved extends ExploreModeState {
  final EnhancedPlaylist playlist;
  final UserTasteProfile tasteProfile;
  final String spotifyPlaylistId;

  const EnhancedPlaylistSaved(
    this.playlist,
    this.tasteProfile,
    this.spotifyPlaylistId,
  );

  @override
  List<Object?> get props => [playlist, tasteProfile, spotifyPlaylistId];
}

class ExploreModeError extends ExploreModeState {
  final String message;

  const ExploreModeError(this.message);

  @override
  List<Object?> get props => [message];
}
