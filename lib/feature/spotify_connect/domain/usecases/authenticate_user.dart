import 'package:injectable/injectable.dart';

import '../entities/auth_token.dart';
import '../repositories/spotify_auth_repo.dart';

@injectable
class AuthenticateUserWithCode {
  final SpotifyAuthRepository repository;

  AuthenticateUserWithCode(this.repository);

  Future<AuthToken?> call(String code) async {
    return await repository.authenticateWithCode(code);
  }
}
