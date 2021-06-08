import 'package:logpass_me/domain/app_security/app_security_type.dart';

abstract class AppSecurityStore {
  Future<void> saveCode(String code);

  Future<bool> compareCode(String code);

  Future<void> saveSecurityType(AppSecurityType type);

  Future<AppSecurityType> loadSecurityType();
}
