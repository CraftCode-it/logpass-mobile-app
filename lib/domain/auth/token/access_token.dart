class AccessToken {
  final String token;
  final String type;

  AccessToken({
    required this.token,
    required this.type,
  });

  /// Returns masked token safe for logs and debug output.
  @override
  String toString() => '$type ${token.length > 10 ? '${token.substring(0, 8)}...' : '***'}';

  /// Returns full authorization header value for HTTP requests.
  String toAuthorizationHeader() => '$type $token';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessToken &&
          runtimeType == other.runtimeType &&
          token == other.token &&
          type == other.type;

  @override
  int get hashCode => Object.hash(token, type);
}
