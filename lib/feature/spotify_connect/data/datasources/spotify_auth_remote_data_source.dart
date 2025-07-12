import 'package:connectspotify/feature/secrets.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:pkce/pkce.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/auth_token.dart';

abstract class SpotifyAuthRemoteDataSource {
  Future<void> authenticateUser();
  Future<AuthToken?> authenticateUserWithCode(String code);
  Future<AuthToken> refreshToken(String refreshToken);
}

@LazySingleton(as: SpotifyAuthRemoteDataSource)
class SpotifyAuthRemoteDataSourceImpl implements SpotifyAuthRemoteDataSource {
  final FlutterSecureStorage storage;
  final Dio dio;

  static final String _clientId = Secrets.clientID;
  static const String _redirectUri = 'myspotifyconnect://callback';

  SpotifyAuthRemoteDataSourceImpl(this.storage, this.dio);

  @override
  Future<void> authenticateUser() async {
    final pkcePair = PkcePair.generate();
    await storage.write(key: 'pkce_code_verifier', value: pkcePair.codeVerifier);

    final authUrl = Uri.https('accounts.spotify.com', '/authorize', {
      'client_id': _clientId,
      'response_type': 'code',
      'redirect_uri': _redirectUri,
      'code_challenge_method': 'S256',
      'code_challenge': pkcePair.codeChallenge,
      'scope': 'user-read-private playlist-read-private playlist-modify-public playlist-modify-private',
    });

    if (!await launchUrl(authUrl, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch Spotify login');
    }
  }

  @override
  Future<AuthToken?> authenticateUserWithCode(String code) async {
    final codeVerifier = await storage.read(key: 'pkce_code_verifier');
    final data = {
      'client_id': _clientId,
      'grant_type': 'authorization_code',
      'code': code,
      'redirect_uri': _redirectUri,
      'code_verifier': codeVerifier,
    };

    try {
      final response = await dio.post(
        'https://accounts.spotify.com/api/token',
        data: data,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final accessToken = response.data['access_token'];
      final refreshToken = response.data['refresh_token'];
      final expiresIn = response.data['expires_in'];

      await storage.write(key: 'access_token', value: accessToken);
      await storage.write(key: 'refresh_token', value: refreshToken);

      return AuthToken(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresIn: expiresIn,
      );
    } catch (e) {
      print('❌ Token exchange error: $e');
      return null;
    }
  }

  @override
  Future<AuthToken> refreshToken(String refreshToken) async {
    final data = {
      'client_id': _clientId,
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken,
    };

    final response = await dio.post(
      'https://accounts.spotify.com/api/token',
      data: data,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    final newAccessToken = response.data['access_token'] as String;
    final newRefreshToken =
        response.data['refresh_token'] as String? ?? refreshToken;
    final expiresIn = response.data['expires_in'] as int;

    await storage.write(key: 'access_token', value: newAccessToken);
    await storage.write(key: 'refresh_token', value: newRefreshToken);

    return AuthToken(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
      expiresIn: expiresIn,
    );
  }
}
