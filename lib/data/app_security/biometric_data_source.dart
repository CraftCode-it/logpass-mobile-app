import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';

@LazySingleton()
class BiometricDataSource {
  final LocalAuthentication _localAuthentication;

  BiometricDataSource(this._localAuthentication);

  Future<List<BiometricType>> availableBiometrics() async {
    return _localAuthentication.getAvailableBiometrics();
  }

  Future<bool> authenticate(String reason) async {
    return _localAuthentication.authenticate(
      localizedReason: reason,
      biometricOnly: true,
    );
  }
}
