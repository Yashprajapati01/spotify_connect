import 'package:injectable/injectable.dart';

import '../../domain/entities/auth_token.dart';
import '../../domain/repositories/spotify_auth_repo.dart';
import '../datasources/spotify_auth_remote_data_source.dart';

@LazySingleton(as: SpotifyAuthRepository)
class SpotifyAuthRepositoryImpl implements SpotifyAuthRepository {
  final SpotifyAuthRemoteDataSource _remoteDataSource;

  SpotifyAuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<void> launchSpotifyAuth() {
    return _remoteDataSource.authenticateUser();
  }

  @override
  Future<AuthToken?> authenticateWithCode(String code) {
    return _remoteDataSource.authenticateUserWithCode(code);
  }

  @override
  Future<AuthToken> refresh(String refreshToken) {
    return _remoteDataSource.refreshToken(refreshToken);
  }
}
