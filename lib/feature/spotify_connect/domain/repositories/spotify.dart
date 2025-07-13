// domain/repositories/spotify_repository.dart
import '../entities/playlist_entity.dart';
import '../entities/track.dart';
import '../entities/user_profile.dart';

abstract class SpotifyRepository {
  Future<UserProfile> getUserProfile();
  Future<List<Playlist>> getUserPlaylists();
  Future<List<Track>> getPlaylistTracks(String playlistId);
  Future<String> createPlaylist(String name, String description, bool isPublic);
  Future<void> addTracksToPlaylist(String playlistId, List<String> trackUris);
}
