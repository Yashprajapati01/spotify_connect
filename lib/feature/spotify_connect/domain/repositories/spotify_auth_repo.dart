import '../entities/auth_token.dart';

import '../entities/auth_token.dart';

abstract class SpotifyAuthRepository {
  /// Triggers login redirect
  Future<void> launchSpotifyAuth();

  /// Exhange code from redirect for tokens
  Future<AuthToken?> authenticateWithCode(String code);

  /// Refresh the access token
  Future<AuthToken> refresh(String refreshToken);
}
