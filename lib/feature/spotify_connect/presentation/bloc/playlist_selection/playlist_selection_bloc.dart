import 'package:bloc/bloc.dart';
import 'package:connectspotify/feature/spotify_connect/presentation/bloc/playlist_selection/playlist_selection_event.dart';
import 'package:connectspotify/feature/spotify_connect/presentation/bloc/playlist_selection/playlist_selection_state.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/playlist_entity.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../domain/usecases/get_user_playlist.dart';
import '../../../domain/usecases/get_user_profile.dart';

@injectable
class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final GetUserProfile _getUserProfile;
  final GetUserPlaylists _getUserPlaylists;

  PlaylistBloc(this._getUserProfile, this._getUserPlaylists)
    : super(PlaylistInitial()) {
    on<LoadUserData>(_onLoadUserData);
    on<RefreshPlaylists>(_onRefreshPlaylists);
  }

  Future<void> _onLoadUserData(
    LoadUserData event,
    Emitter<PlaylistState> emit,
  ) async {
    emit(PlaylistLoading());
    try {
      // Fetch user profile and playlists concurrently
      final results = await Future.wait([
        _getUserProfile(),
        _getUserPlaylists(),
      ]);

      final userProfile = results[0] as UserProfile;
      final playlists = results[1] as List<Playlist>;

      emit(PlaylistLoaded(userProfile: userProfile, playlists: playlists));
    } catch (e) {
      emit(PlaylistError('Failed to load user data: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshPlaylists(
    RefreshPlaylists event,
    Emitter<PlaylistState> emit,
  ) async {
    // Don't show loading if we already have data
    if (state is! PlaylistLoaded) {
      emit(PlaylistLoading());
    }

    try {
      final results = await Future.wait([
        _getUserProfile(),
        _getUserPlaylists(),
      ]);

      final userProfile = results[0] as UserProfile;
      final playlists = results[1] as List<Playlist>;

      emit(PlaylistLoaded(userProfile: userProfile, playlists: playlists));
    } catch (e) {
      emit(PlaylistError('Failed to refresh playlists: ${e.toString()}'));
    }
  }
}
