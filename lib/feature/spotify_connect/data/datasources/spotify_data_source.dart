// // data/datasources/spotify_data_source.dart
// import 'package:dio/dio.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:injectable/injectable.dart';
// import '../../domain/entities/playlist_entity.dart';
// import '../../domain/entities/user_profile.dart';
//
// abstract class SpotifyDataSource {
//   Future<UserProfile> getUserProfile();
//   Future<List<Playlist>> getUserPlaylists();
// }
//
// @LazySingleton(as: SpotifyDataSource)
// class SpotifyDataSourceImpl implements SpotifyDataSource {
//   final Dio dio;
//   final FlutterSecureStorage storage;
//
//   SpotifyDataSourceImpl(this.dio, this.storage);
//
//   Future<String?> _getAccessToken() async {
//     return await storage.read(key: 'access_token');
//   }
//
//   Future<Options> _getAuthHeaders() async {
//     final token = await _getAccessToken();
//     if (token == null) throw Exception('No access token found');
//
//     return Options(
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//     );
//   }
//
//   @override
//   Future<UserProfile> getUserProfile() async {
//     try {
//       final response = await dio.get(
//         'https://api.spotify.com/v1/me',
//         options: await _getAuthHeaders(),
//       );
//
//       final data = response.data;
//       return UserProfile(
//         id: data['id'] ?? '',
//         displayName: data['display_name'] ?? 'Unknown User',
//         email: data['email'] ?? '',
//         imageUrl: data['images']?.isNotEmpty == true
//             ? data['images'][0]['url']
//             : null,
//         followerCount: data['followers']?['total'] ?? 0,
//       );
//     } catch (e) {
//       print('❌ Error fetching user profile: $e');
//       rethrow;
//     }
//   }
//
//   @override
//   Future<List<Playlist>> getUserPlaylists() async {
//     try {
//       final response = await dio.get(
//         'https://api.spotify.com/v1/me/playlists',
//         queryParameters: {'limit': 50},
//         options: await _getAuthHeaders(),
//       );
//
//       final data = response.data;
//       final List<dynamic> items = data['items'] ?? [];
//
//       return items.map((item) {
//         return Playlist(
//           id: item['id'] ?? '',
//           name: item['name'] ?? 'Unknown Playlist',
//           description: item['description'],
//           imageUrl: item['images']?.isNotEmpty == true
//               ? item['images'][0]['url']
//               : null,
//           trackCount: item['tracks']?['total'] ?? 0,
//           isPublic: item['public'] ?? false,
//           ownerName: item['owner']?['display_name'] ?? 'Unknown',
//           ownerId: item['owner']?['id'],
//         );
//       }).toList();
//     } catch (e) {
//       print('❌ Error fetching playlists: $e');
//       rethrow;
//     }
//   }
// }

// data/datasources/spotify_data_source.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/playlist_entity.dart';
import '../../domain/entities/track.dart';
import '../../domain/entities/user_profile.dart';
import 'spotify_auth_remote_data_source.dart';

abstract class SpotifyDataSource {
  Future<UserProfile> getUserProfile();
  Future<List<Playlist>> getUserPlaylists();
  Future<List<Track>> getPlaylistTracks(String playlistId);
  Future<String> createPlaylist(String name, String description, bool isPublic);
  Future<void> addTracksToPlaylist(String playlistId, List<String> trackUris);
}

@LazySingleton(as: SpotifyDataSource)
class SpotifyDataSourceImpl implements SpotifyDataSource {
  final Dio dio;
  final FlutterSecureStorage storage;
  final SpotifyAuthRemoteDataSource authDataSource;

  SpotifyDataSourceImpl(this.dio, this.storage, this.authDataSource);
  // Store token expiry when getting/refreshing tokens
  Future<void> _storeTokenExpiry(int expiresIn) async {
    final expiryTime = DateTime.now().add(Duration(seconds: expiresIn));
    await storage.write(
      key: 'token_expires_at',
      value: expiryTime.toIso8601String(),
    );
  }

  // Check if token is expired
  Future<bool> _isTokenExpired() async {
    final expiryString = await storage.read(key: 'token_expires_at');
    if (expiryString == null) return true;

    final expiryTime = DateTime.parse(expiryString);
    // Add 5 minute buffer before actual expiry
    return DateTime.now().isAfter(expiryTime.subtract(Duration(minutes: 5)));
  }

  // Get valid access token (refresh if needed)
  Future<String?> _getValidAccessToken() async {
    final token = await storage.read(key: 'access_token');
    if (token == null) return null;

    // Check if token is expired
    if (await _isTokenExpired()) {
      print('🔄 Token expired, refreshing...');
      final refreshToken = await storage.read(key: 'refresh_token');
      if (refreshToken == null) {
        print('❌ No refresh token found');
        return null;
      }

      try {
        final newAuthToken = await authDataSource.refreshToken(refreshToken);
        await _storeTokenExpiry(newAuthToken.expiresIn);
        print('✅ Token refreshed successfully');
        return newAuthToken.accessToken;
      } catch (e) {
        print('❌ Failed to refresh token: $e');
        return null;
      }
    }

    return token;
  }

  // Get authorization headers with automatic token refresh
  Future<Options> _getAuthHeaders() async {
    final token = await _getValidAccessToken();
    if (token == null) throw Exception('Unable to get valid access token');

    return Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  // Execute API calls with automatic retry on 401 errors
  Future<Response<T>> _executeWithRetry<T>(
    Future<Response<T>> Function() apiCall,
  ) async {
    try {
      return await apiCall();
    } on DioException catch (e) {
      // If 401 error, try to refresh token once and retry
      if (e.response?.statusCode == 401) {
        print('🔄 Got 401 error, attempting token refresh...');

        final refreshToken = await storage.read(key: 'refresh_token');
        if (refreshToken == null) {
          throw Exception('No refresh token available');
        }

        try {
          final newAuthToken = await authDataSource.refreshToken(refreshToken);
          await _storeTokenExpiry(newAuthToken.expiresIn);
          print('✅ Token refreshed, retrying API call...');

          // Retry the original API call with new token
          return await apiCall();
        } catch (refreshError) {
          print('❌ Token refresh failed: $refreshError');
          throw Exception('Authentication failed - please login again');
        }
      }
      rethrow;
    }
  }

  @override
  Future<UserProfile> getUserProfile() async {
    try {
      final response = await _executeWithRetry(
        () async => dio.get(
          'https://api.spotify.com/v1/me',
          options: await _getAuthHeaders(),
        ),
      );

      final data = response.data;
      print('✅ Fetched user profile: $data');
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
      final response = await _executeWithRetry(
        () async => dio.get(
          'https://api.spotify.com/v1/me/playlists',
          queryParameters: {'limit': 50},
          options: await _getAuthHeaders(),
        ),
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

  @override
  Future<List<Track>> getPlaylistTracks(String playlistId) async {
    try {
      final allTracks = <Track>[];
      String? nextUrl =
          'https://api.spotify.com/v1/playlists/$playlistId/tracks';

      while (nextUrl != null) {
        final response = await dio.get(
          nextUrl,
          queryParameters: {'limit': 100},
          options: await _getAuthHeaders(),
        );

        final data = response.data;
        final List<dynamic> items = data['items'] ?? [];

        for (final item in items) {
          final track = item['track'];
          if (track != null && track['id'] != null) {
            allTracks.add(
              Track(
                id: track['id'],
                name: track['name'] ?? 'Unknown Track',
                artistName: track['artists']?.isNotEmpty == true
                    ? track['artists'][0]['name']
                    : 'Unknown Artist',
                albumName: track['album']?['name'] ?? 'Unknown Album',
                imageUrl: track['album']?['images']?.isNotEmpty == true
                    ? track['album']['images'][0]['url']
                    : null,
                durationMs: track['duration_ms'] ?? 0,
                uri: track['uri'] ?? '',
                artists:
                    (track['artists'] as List<dynamic>?)
                        ?.map((artist) => artist['name'] as String)
                        .toList() ??
                    [],
                previewUrl: track['preview_url'],
                isExplicit: track['explicit'] ?? false,
                popularity: track['popularity'] ?? 0,
              ),
            );
          }
        }

        nextUrl = data['next'];
      }

      print('✅ Fetched ${allTracks.length} tracks from playlist $playlistId');
      return allTracks;
    } catch (e) {
      print('❌ Error fetching playlist tracks: $e');
      rethrow;
    }
  }

  Future<String?> _getUserId() async {
    try {
      final profile = await getUserProfile();
      return profile.id;
    } catch (e) {
      print('❌ Failed to get user ID: $e');
      return null;
    }
  }

  @override
  Future<String> createPlaylist(
    String name,
    String description,
    bool isPublic,
  ) async {
    try {
      final userId = await _getUserId();
      if (userId == null) throw Exception('User ID not found');

      final response = await dio.post(
        'https://api.spotify.com/v1/users/$userId/playlists',
        data: {'name': name, 'description': description, 'public': isPublic},
        options: await _getAuthHeaders(),
      );

      final playlistId = response.data['id'];
      print('✅ Created playlist: $name (ID: $playlistId)');
      return playlistId;
    } catch (e) {
      print('❌ Error creating playlist: $e');
      rethrow;
    }
  }

  @override
  Future<void> addTracksToPlaylist(
    String playlistId,
    List<String> trackUris,
  ) async {
    try {
      // Spotify API allows max 100 tracks per request
      const batchSize = 100;

      for (int i = 0; i < trackUris.length; i += batchSize) {
        final batch = trackUris.skip(i).take(batchSize).toList();

        await dio.post(
          'https://api.spotify.com/v1/playlists/$playlistId/tracks',
          data: {'uris': batch},
          options: await _getAuthHeaders(),
        );
      }

      print('✅ Added ${trackUris.length} tracks to playlist $playlistId');
    } catch (e) {
      print('❌ Error adding tracks to playlist: $e');
      rethrow;
    }
  }
}
