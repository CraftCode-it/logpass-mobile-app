import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logpass_me/data/app_security/biometric_data_source.dart';
import 'package:logpass_me/domain/app_security/app_security_repository.dart';

@LazySingleton(as: AppSecurityRepository)
class AppSecurityRepositoryImpl implements AppSecurityRepository {
  final BiometricDataSource _biometricDataSource;

  AppSecurityRepositoryImpl(this._biometricDataSource);

  @override
  Future<bool> authenticate() async {
    return _biometricDataSource.authenticate('Reason'); //TODO find best way to pass reason
  }

  @override
  Future<bool> supportsBiometric() async {
    final availableBiometrics = await _biometricDataSource.availableBiometrics();

    final isBiometricSupports = availableBiometrics.any((element) =>
        element == BiometricType.face ||
        element == BiometricType.fingerprint
    );

    if(Platform.isIOS && !isBiometricSupports) {
      return _biometricDataSource.isBiometricIOSDeviceSupported();
    }

    return isBiometricSupports;
  }
}
