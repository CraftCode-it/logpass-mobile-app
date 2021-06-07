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
    final savedEncryptedCode = await _appSecurityDatabase.loadCode();
    final encryptedCode = _encryptor.encrypt(code);

    return savedEncryptedCode == encryptedCode;
  }

  @override
  Future<AppSecurityType> loadSecurityType() async {
    final rawType = await _appSecurityDatabase.loadSecurityType();

    if (rawType == null) return AppSecurityType.none;

    return _mapper.to(rawType);
  }

  @override
  Future<void> saveCode(String code) async {
    final encryptedCode = _encryptor.encrypt(code);
    await _appSecurityDatabase.saveCode(encryptedCode);
  }

  @override
  Future<void> saveSecurityType(AppSecurityType type) async {
    final entity = _mapper.from(type);
    await _appSecurityDatabase.saveSecurityType(entity);
  }
}
