import 'package:injectable/injectable.dart';
import '../../domain/entities/playlist_entity.dart';
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
}