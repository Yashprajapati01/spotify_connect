// domain/repositories/spotify_repository.dart
import '../entities/playlist_entity.dart';
import '../entities/user_profile.dart';

abstract class SpotifyRepository {
  Future<UserProfile> getUserProfile();
  Future<List<Playlist>> getUserPlaylists();
}