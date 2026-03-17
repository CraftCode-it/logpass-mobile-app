import 'dart:convert';

import 'package:logpass_me/data/common/serializable_dto.dart';
import 'package:logpass_me/data/user_data/cipher/user_data_cipher.dart';

class EncryptedRepository<T extends SerializableDto> {
  final UserDataCipher _cipher;

  EncryptedRepository(this._cipher);

  String encrypt(T data) {
    final serializedData = data.toJson();

    return json.encode(serializedData);
  }

  Map<String, dynamic> decrypt(String data) {
    return jsonDecode(data) as Map<String, dynamic>;
  }
}
