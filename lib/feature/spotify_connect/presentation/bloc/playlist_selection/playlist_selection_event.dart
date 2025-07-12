
// presentation/bloc/playlist/playlist_event.dart
import 'package:equatable/equatable.dart';

abstract class PlaylistEvent extends Equatable {
  const PlaylistEvent();

  @override
  List<Object> get props => [];
}

class LoadUserData extends PlaylistEvent {}

class RefreshPlaylists extends PlaylistEvent {}