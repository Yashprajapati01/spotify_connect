import '../../domain/entities/auth_token.dart';

class TokenModel extends AuthToken {
  TokenModel({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
  }) : super(
    accessToken: accessToken,
    refreshToken: refreshToken,
    expiresIn: expiresIn,
  );

  factory TokenModel.fromJson(Map<String, dynamic> json) => TokenModel(
    accessToken: json['access_token'],
    refreshToken: json['refresh_token'],
    expiresIn: json['expires_in'],
  );
}
