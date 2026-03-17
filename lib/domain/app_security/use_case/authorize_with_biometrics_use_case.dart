import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/error_codes.dart' as AuthBiometricError;
import 'package:logpass_me/domain/app_security/app_security_repository.dart';
import 'package:logpass_me/domain/app_security/exception/biometric_not_available_exception.dart';
import 'package:logpass_me/domain/app_security/exception/biometric_not_supported_exception.dart';

@Injectable()
class AuthorizeWithBiometricsUseCase {
  final AppSecurityRepository _appSecurityRepository;

  AuthorizeWithBiometricsUseCase(this._appSecurityRepository);

  Future<bool> call() async {
    try {
      return await _appSecurityRepository.authenticate();
    } catch (e) {
      final isBiometricSupported = await _appSecurityRepository.supportsBiometric();

      if(isBiometricSupported && _isBiometricNotAvailable(e)) {
        throw BiometricNotAvailableException();
      } else if(!isBiometricSupported) {
        throw BiometricNotSupportedException();
      }

      rethrow;
    }
  }

  bool _isBiometricNotAvailable(Object e) {
    return e is PlatformException && e.code == AuthBiometricError.notAvailable;
  }
}
