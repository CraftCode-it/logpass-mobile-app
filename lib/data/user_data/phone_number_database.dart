import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

const _key = 'logpassPhoneNumber';
const _iosOptions = IOSOptions(accessibility: KeychainAccessibility.unlocked_this_device);

@LazySingleton()
class PhoneNumberDatabase {
  final FlutterSecureStorage _storage;

  const PhoneNumberDatabase(this._storage);

  Future<void> savePhoneNumber(String number) async {
    await _storage.write(key: _key, value: number, iOptions: _iosOptions);
  }

  Future<String?> loadPhoneNumber() {
    return _storage.read(key: _key, iOptions: _iosOptions);
  }

  Future<void> clear() => _storage.delete(key: _key, iOptions: _iosOptions);
}
