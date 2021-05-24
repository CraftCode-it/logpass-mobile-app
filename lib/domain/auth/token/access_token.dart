class AccessToken {
  final String token;
  final String type;

  AccessToken({
    required this.token,
    required this.type,
  });

  @override
  String toString() => '$type $token';
}
