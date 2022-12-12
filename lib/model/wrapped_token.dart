class WrappedToken {
  final String accessToken;
  final String refreshToken;

  WrappedToken({required this.accessToken, required this.refreshToken});

  factory WrappedToken.fromJson(Map<String, dynamic> json) => WrappedToken(
      accessToken: json['access_token']!, refreshToken: json['refresh_token']!);

  Map<String, dynamic> toJson() =>
      {'access_token': accessToken, 'refresh_token': refreshToken};
}
