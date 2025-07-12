// data/datasources/spotify_data_source.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/playlist_entity.dart';
import '../../domain/entities/user_profile.dart';

abstract class SpotifyDataSource {
  Future<UserProfile> getUserProfile();
  Future<List<Playlist>> getUserPlaylists();
}

@LazySingleton(as: SpotifyDataSource)
class SpotifyDataSourceImpl implements SpotifyDataSource {
  final Dio dio;
  final FlutterSecureStorage storage;

  SpotifyDataSourceImpl(this.dio, this.storage);

  Future<String?> _getAccessToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<Options> _getAuthHeaders() async {
    final token = await _getAccessToken();
    if (token == null) throw Exception('No access token found');

    return Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  @override
  Future<UserProfile> getUserProfile() async {
    try {
      final response = await dio.get(
        'https://api.spotify.com/v1/me',
        options: await _getAuthHeaders(),
      );

      final data = response.data;
      return UserProfile(
        id: data['id'] ?? '',
        displayName: data['display_name'] ?? 'Unknown User',
        email: data['email'] ?? '',
        imageUrl: data['images']?.isNotEmpty == true
            ? data['images'][0]['url']
            : null,
        followerCount: data['followers']?['total'] ?? 0,
      );
    } catch (e) {
      print('❌ Error fetching user profile: $e');
      rethrow;
    }
  }

  @override
  Future<List<Playlist>> getUserPlaylists() async {
    try {
      final response = await dio.get(
        'https://api.spotify.com/v1/me/playlists',
        queryParameters: {'limit': 50},
        options: await _getAuthHeaders(),
      );

      final data = response.data;
      final List<dynamic> items = data['items'] ?? [];

      return items.map((item) {
        return Playlist(
          id: item['id'] ?? '',
          name: item['name'] ?? 'Unknown Playlist',
          description: item['description'],
          imageUrl: item['images']?.isNotEmpty == true
              ? item['images'][0]['url']
              : null,
          trackCount: item['tracks']?['total'] ?? 0,
          isPublic: item['public'] ?? false,
          ownerName: item['owner']?['display_name'] ?? 'Unknown',
          ownerId: item['owner']?['id'],
        );
      }).toList();
    } catch (e) {
      print('❌ Error fetching playlists: $e');
      rethrow;
    }
  }
}