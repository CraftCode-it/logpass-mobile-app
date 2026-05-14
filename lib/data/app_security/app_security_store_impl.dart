import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/app_security/app_code_encryptor.dart';
import 'package:logpass_me/data/app_security/app_security_database.dart';
import 'package:logpass_me/data/app_security/app_security_type_entity_mapper.dart';
import 'package:logpass_me/domain/app_security/app_security_store.dart';
import 'package:logpass_me/domain/app_security/app_security_type.dart';

@LazySingleton(as: AppSecurityStore)
class AppSecurityStoreImpl implements AppSecurityStore {
  final AppSecurityDatabase _appSecurityDatabase;
  final AppSecurityTypeEntityMapper _mapper;
  final AppCodeEncryptor _encryptor;

  AppSecurityStoreImpl(this._appSecurityDatabase, this._mapper, this._encryptor);

  @override
  Future<bool> compareCode(String code) async {
    final saved = await _appSecurityDatabase.loadCode();
    if (saved == null) return false;

    // Migrate legacy SHA-256 hex hash to PBKDF2 on first correct login.
    if (_encryptor.isLegacyHash(saved)) {
      final legacyHash = _legacySha256(code);
      if (legacyHash != saved) return false;
      final newHash = await _encryptor.encrypt(code);
      await _appSecurityDatabase.saveCode(newHash);
      return true;
    }

    return _encryptor.verify(code, saved);
  }

  @override
  Future<AppSecurityType> loadSecurityType() async {
    final rawType = await _appSecurityDatabase.loadSecurityType();
    if (rawType == null) return AppSecurityType.none;
    return _mapper.to(rawType);
  }

  @override
  Future<void> saveCode(String code) async {
    final hashed = await _encryptor.encrypt(code);
    await _appSecurityDatabase.saveCode(hashed);
  }

  @override
  Future<void> saveSecurityType(AppSecurityType type) async {
    final entity = _mapper.from(type);
    await _appSecurityDatabase.saveSecurityType(entity);
  }

  @override
  Future<void> clear() async {
    await _appSecurityDatabase.clear();
  }

  String _legacySha256(String code) =>
      sha256.convert(utf8.encode(code)).toString();
}
