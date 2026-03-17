class OneTimeCode {
  final String code;
  final Duration expirationSec;
  final DateTime creationTime;
  final DateTime expirationTime;

  OneTimeCode(
    this.code,
    this.expirationSec,
    this.creationTime,
    this.expirationTime,
  );

  bool get isExpired {
    final now = DateTime.now();
    return now.millisecondsSinceEpoch >= expirationTime.millisecondsSinceEpoch;
  }
}
