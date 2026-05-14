import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AppSecurityDatabase {
  static const _typeKey = 'logPassAppSecurityType';
  static const _codeKey = 'logPassAppSecurityCode';
  static const _iosOptions = IOSOptions(accessibility: KeychainAccessibility.unlocked_this_device);

  final FlutterSecureStorage _storage;

  AppSecurityDatabase(this._storage);

  Future<void> saveCode(String code) async {
    await _storage.write(key: _codeKey, value: code, iOptions: _iosOptions);
  }

  Future<String?> loadCode() async {
    return _storage.read(key: _codeKey, iOptions: _iosOptions);
  }

  Future<void> saveSecurityType(String type) async {
    await _storage.write(key: _typeKey, value: type, iOptions: _iosOptions);
  }

  Future<String?> loadSecurityType() async {
    return _storage.read(key: _typeKey, iOptions: _iosOptions);
  }

  Future<void> clear() async {
    await _storage.delete(key: _codeKey);
    await _storage.delete(key: _typeKey);
  }
}
