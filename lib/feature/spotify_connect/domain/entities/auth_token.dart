class AuthToken {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  AuthToken({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });
}
