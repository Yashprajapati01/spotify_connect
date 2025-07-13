import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String displayName;
  final String email;
  final String? imageUrl;
  final int followerCount;

  const UserProfile({
    required this.id,
    required this.displayName,
    required this.email,
    this.imageUrl,
    required this.followerCount,
  });

  @override
  List<Object?> get props => [id, displayName, email, imageUrl, followerCount];
}
