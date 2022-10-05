class WrappedToken {
  final String accessToken;
  final String refreshToken;

  WrappedToken({required this.accessToken, required this.refreshToken});

  factory WrappedToken.fromJson(Map<String, String> json) => WrappedToken(
      accessToken: json['access_token']!, refreshToken: json['refresh_token']!);

  Map<String, String> toJson() =>
      {'access_token': accessToken, 'refresh_token': refreshToken};
}
