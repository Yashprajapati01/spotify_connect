
import '../entities/playlist_entity.dart';

abstract class SpotifyPlaylistRepository {
  Future<List<Playlist>> getUserPlaylists();
}