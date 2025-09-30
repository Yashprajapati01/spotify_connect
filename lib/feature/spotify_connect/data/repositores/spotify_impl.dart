import 'package:injectable/injectable.dart';
import '../../domain/entities/playlist_entity.dart';
import '../../domain/entities/track.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/spotify.dart';
import '../datasources/spotify_data_source.dart';

@LazySingleton(as: SpotifyRepository)
class SpotifyRepositoryImpl implements SpotifyRepository {
  final SpotifyDataSource dataSource;

  SpotifyRepositoryImpl(this.dataSource);

  @override
  Future<UserProfile> getUserProfile() async {
    try {
      return await dataSource.getUserProfile();
    } catch (e) {
      print('❌ Repository error - getUserProfile: $e');
      rethrow;
    }
  }

  @override
  Future<List<Playlist>> getUserPlaylists() async {
    try {
      return await dataSource.getUserPlaylists();
    } catch (e) {
      print('❌ Repository error - getUserPlaylists: $e');
      rethrow;
    }
  }

  @override
  Future<List<Track>> getPlaylistTracks(String playlistId) async {
    try {
      return await dataSource.getPlaylistTracks(playlistId);
    } catch (e) {
      print('❌ Repository error - getPlaylistTracks: $e');
      rethrow;
    }
  }

  @override
  Future<String> createPlaylist(
    String name,
    String description,
    bool isPublic,
  ) async {
    try {
      return await dataSource.createPlaylist(name, description, isPublic);
    } catch (e) {
      print('❌ Repository error - createPlaylist: $e');
      rethrow;
    }
  }

  @override
  Future<void> addTracksToPlaylist(
    String playlistId,
    List<String> trackUris,
  ) async {
    try {
      await dataSource.addTracksToPlaylist(playlistId, trackUris);
    } catch (e) {
      print('❌ Repository error - addTracksToPlaylist: $e');
      rethrow;
    }
  }

  @override
  Future<List<Track>> getRecommendations({
    List<String>? seedTracks,
    List<String>? seedArtists,
    List<String>? seedGenres,
    double? targetEnergy,
    double? targetDanceability,
    double? targetValence,
    int limit = 20,
  }) async {
    try {
      return await dataSource.getRecommendations(
        seedTracks: seedTracks,
        seedArtists: seedArtists,
        seedGenres: seedGenres,
        targetEnergy: targetEnergy,
        targetDanceability: targetDanceability,
        targetValence: targetValence,
        limit: limit,
      );
    } catch (e) {
      print('❌ Repository error - getRecommendations: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getAudioFeatures(String trackId) async {
    try {
      return await dataSource.getAudioFeatures(trackId);
    } catch (e) {
      print('❌ Repository error - getAudioFeatures: $e');
      rethrow;
    }
  }

  @override
  Future<List<String>> getAvailableGenres() async {
    try {
      return await dataSource.getAvailableGenres();
    } catch (e) {
      print('❌ Repository error - getAvailableGenres: $e');
      rethrow;
    }
  }
}
