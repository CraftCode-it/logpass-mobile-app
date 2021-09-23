import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/serializable_dto.dart';
import 'package:logpass_me/domain/crypto/crypto_key_provider.dart';

@injectable
class UserDataCipher {
  final CryptoKeyProvider _keyProvider;

  UserDataCipher(this._keyProvider);

  String encrypt<T extends SerializableDto>(T data) {
    final serializedData = data.toJson();

    return json.encode(serializedData);
  }

  T decrypt<T>(String data, T Function ( Map<String, dynamic> data) creator) {
    final map =  jsonDecode(data) as Map<String, dynamic>;
    return creator(map);
  }
}
