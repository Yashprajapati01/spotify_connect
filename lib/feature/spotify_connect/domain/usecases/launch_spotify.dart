import 'package:injectable/injectable.dart';

import '../repositories/spotify_auth_repo.dart';

@injectable
class LaunchSpotifyAuth {
  final SpotifyAuthRepository repository;
  LaunchSpotifyAuth(this.repository);

  Future<void> call() async => await repository.launchSpotifyAuth();
}