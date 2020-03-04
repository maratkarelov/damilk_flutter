class TokenModel {
  final String token;
  final String expiresAt; //format 2020-02-17T16:23:54.085Z

  TokenModel(this.token, this.expiresAt);

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(json['token'] as String,
        json['expires_at'] as String);
  }
}