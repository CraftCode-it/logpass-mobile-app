import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:injectable/injectable.dart';

/// PIN hashing with PBKDF2-SHA256 + random salt.
///
/// Storage format: "$v2$<salt_base64>$<hash_base64>"
/// Legacy format (plain SHA-256 hex): no prefix -- detected by absence of "$v2$"
@Injectable()
class AppCodeEncryptor {
  static const _prefix = r'$v2$';
  static const _iterations = 100000;
  static const _bits = 256;
  static const _saltBytes = 16;

  final _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: _iterations,
    bits: _bits,
  );

  /// Returns true if [stored] is a legacy SHA-256 hex hash (no v2 prefix).
  bool isLegacyHash(String stored) => !stored.startsWith(_prefix);

  /// Hashes [code] with a new random salt. Result is the v2 format string.
  Future<String> encrypt(String code) async {
    final salt = _randomSalt();
    final hash = await _derive(code, salt);
    return '$_prefix${base64Encode(salt)}\$${base64Encode(hash)}';
  }

  /// Verifies [code] against a v2 hash string produced by [encrypt].
  Future<bool> verify(String code, String stored) async {
    if (!stored.startsWith(_prefix)) return false;
    final parts = stored.substring(_prefix.length).split(r'$');
    if (parts.length != 2) return false;
    final salt = base64Decode(parts[0]);
    final expectedHash = base64Decode(parts[1]);
    final actualHash = await _derive(code, salt);
    return _constantTimeEquals(actualHash, expectedHash);
  }

  Future<Uint8List> _derive(String code, List<int> salt) async {
    final secretKey = SecretKey(utf8.encode(code));
    final result = await _pbkdf2.deriveKey(secretKey: secretKey, nonce: salt);
    return Uint8List.fromList(await result.extractBytes());
  }

  List<int> _randomSalt() {
    final rng = Random.secure();
    return List<int>.generate(_saltBytes, (_) => rng.nextInt(256));
  }

  bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a[i] ^ b[i];
    }
    return result == 0;
  }
}
