import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/auth/storage/user_tokens_entity.dart';

@Singleton()
class AuthSecureDatabase {
  static const _key = 'logPassUserTokens';
  static const _iosOptions = IOSOptions(accessibility: IOSAccessibility.unlocked_this_device);

  final FlutterSecureStorage _storage;

  AuthSecureDatabase(this._storage);

  Future<void> saveTokens(UserTokensEntity entity) async {
    final json = jsonEncode(entity.toJson());
    await _storage.write(
      key: _key,
      value: json,
      iOptions: _iosOptions,
    );
  }

  Future<UserTokensEntity?> loadTokens() async {
    final json = await _storage.read(key: _key, iOptions: _iosOptions);

    if (json == null) return null;

    return UserTokensEntity.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> clear() => _storage.delete(key: _key, iOptions: _iosOptions);
}
