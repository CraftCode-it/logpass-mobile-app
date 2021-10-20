import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app_security/app_security_repository.dart';
import 'package:logpass_me/domain/app_security/exception/biometric_not_available_exception.dart';

const _biometricNotAvailableCode = 'NotAvailable';

@Injectable()
class AuthorizeWithBiometricsUseCase {
  final AppSecurityRepository _appSecurityRepository;

  AuthorizeWithBiometricsUseCase(this._appSecurityRepository);

  Future<bool> call() async {
    try {
      return await _appSecurityRepository.authenticate();
    } catch (e) {
      if (_isBiometricNotAvailable(e)) {
        throw BiometricNotAvailableException();
      }
      rethrow;
    }
  }

  bool _isBiometricNotAvailable(Object e) {
    return e is PlatformException && e.code == _biometricNotAvailableCode;
  }
}
