import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

abstract class SpotifyPlaylistRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchUserPlaylistsRaw();
}

@LazySingleton(as: SpotifyPlaylistRemoteDataSource)
class SpotifyPlaylistRemoteDataSourceImpl
    implements SpotifyPlaylistRemoteDataSource {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  SpotifyPlaylistRemoteDataSourceImpl(this._dio, this._storage);

  @override
  Future<List<Map<String, dynamic>>> fetchUserPlaylistsRaw() async {
    final token = await _storage.read(key: 'access_token');
    final response = await _dio.get(
      'https://api.spotify.com/v1/me/playlists',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return List<Map<String, dynamic>>.from(response.data['items']);
  }
}
