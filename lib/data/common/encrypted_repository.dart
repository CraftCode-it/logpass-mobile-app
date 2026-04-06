import 'package:logpass_me/data/common/serializable_dto.dart';
import 'package:logpass_me/data/user_data/cipher/user_data_cipher.dart';

class EncryptedRepository<T extends SerializableDto> {
  final UserDataCipher _cipher;

  EncryptedRepository(this._cipher);

  Future<String> encrypt(T data) => _cipher.encrypt(data);

  Future<Map<String, dynamic>> decrypt(String data) =>
      _cipher.decrypt(data, (map) => map);
}
