import 'package:logpass_me/domain/app_security/app_security_type.dart';
import 'package:logpass_me/domain/common/clearable.dart';

abstract class AppSecurityStore implements Clearable {
  Future<void> saveCode(String code);

  Future<bool> compareCode(String code);

  Future<void> saveSecurityType(AppSecurityType type);

  Future<AppSecurityType> loadSecurityType();
}
