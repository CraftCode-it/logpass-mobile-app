import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class KeyProvider {
  final FlutterSecureStorage _storage;
  static const _privateKeyKey = 'logpass_ed25519_private';
  static const _publicKeyKey = 'logpass_ed25519_public';

  KeyProvider(this._storage);

  Future<String> getUserPubkeyHex() async {
    var pubHex = await _storage.read(key: _publicKeyKey);
    if (pubHex != null) return pubHex;

    final algorithm = Ed25519();
    final keyPair = await algorithm.newKeyPair();
    final pubKey = await keyPair.extractPublicKey();

    final privBytes = await keyPair.extractPrivateKeyBytes();
    final pubBytes = pubKey.bytes;

    await _storage.write(key: _privateKeyKey, value: _bytesToHex(privBytes));
    pubHex = _bytesToHex(pubBytes);
    await _storage.write(key: _publicKeyKey, value: pubHex);

    return pubHex;
  }

  Future<Uint8List?> getPrivateKeyBytes() async {
    final hexStr = await _storage.read(key: _privateKeyKey);
    if (hexStr == null) return null;
    return _hexToBytes(hexStr);
  }

  Future<bool> hasKeyPair() async {
    final pub = await _storage.read(key: _publicKeyKey);
    return pub != null;
  }

  String _bytesToHex(List<int> bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  Uint8List _hexToBytes(String hex) {
    final result = Uint8List(hex.length ~/ 2);
    for (var i = 0; i < hex.length; i += 2) {
      result[i ~/ 2] = int.parse(hex.substring(i, i + 2), radix: 16);
    }
    return result;
  }
}
