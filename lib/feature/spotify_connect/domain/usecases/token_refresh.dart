import '../entities/auth_token.dart';
import '../repositories/spotify_auth_repo.dart';

class RefreshToken {
  final SpotifyAuthRepository repository;

  RefreshToken(this.repository);

  Future<AuthToken?> call(String token) async {
    try {
      return await repository.refresh(token);
    } catch (_) {
      return null;
    }
  }
}
