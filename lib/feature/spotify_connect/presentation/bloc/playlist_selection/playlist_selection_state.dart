// presentation/bloc/playlist/playlist_state.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/playlist_entity.dart';
import '../../../domain/entities/user_profile.dart';

abstract class PlaylistState extends Equatable {
  const PlaylistState();

  @override
  List<Object?> get props => [];
}

class PlaylistInitial extends PlaylistState {}

class PlaylistLoading extends PlaylistState {}

class PlaylistLoaded extends PlaylistState {
  final UserProfile userProfile;
  final List<Playlist> playlists;

  const PlaylistLoaded({
    required this.userProfile,
    required this.playlists,
  });

  @override
  List<Object?> get props => [userProfile, playlists];
}

class PlaylistError extends PlaylistState {
  final String message;

  const PlaylistError(this.message);

  @override
  List<Object?> get props => [message];
}