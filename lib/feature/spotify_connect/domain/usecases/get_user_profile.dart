// domain/usecases/get_user_profile.dart
import 'package:injectable/injectable.dart';
import '../entities/user_profile.dart';
import '../repositories/spotify.dart';

@injectable
class GetUserProfile {
  final SpotifyRepository repository;

  GetUserProfile(this.repository);

  Future<UserProfile> call() async {
    return await repository.getUserProfile();
  }
}
