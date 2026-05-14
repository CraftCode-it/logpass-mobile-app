import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/serializable_dto.dart';
import 'package:logpass_me/domain/crypto/crypto_key_provider.dart';

@injectable
class UserDataCipher {
  final CryptoKeyProvider _keyProvider;
  static final _algorithm = AesGcm.with256bits();

  UserDataCipher(this._keyProvider);

  Future<String> encrypt<T extends SerializableDto>(T data) async {
    final keyBytes = await _keyProvider.getKey();
    final secretKey = SecretKey(Uint8List.fromList(keyBytes.sublist(0, 32)));
    final jsonStr = json.encode(data.toJson());
    final nonce = _algorithm.newNonce();
    final secretBox = await _algorithm.encrypt(
      utf8.encode(jsonStr),
      secretKey: secretKey,
      nonce: nonce,
    );
    return base64Encode(secretBox.concatenation());
  }

  Future<T> decrypt<T>(String data, T Function(Map<String, dynamic> data) creator) async {
    final keyBytes = await _keyProvider.getKey();
    final secretKey = SecretKey(Uint8List.fromList(keyBytes.sublist(0, 32)));
    final bytes = base64Decode(data);
    final secretBox = SecretBox.fromConcatenation(
      bytes,
      nonceLength: 12,
      macLength: 16,
    );
    final clearText = await _algorithm.decrypt(secretBox, secretKey: secretKey);
    return creator(jsonDecode(utf8.decode(clearText)) as Map<String, dynamic>);
  }
}
