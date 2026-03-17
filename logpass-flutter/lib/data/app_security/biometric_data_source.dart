import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';

/// The first iPhone which support biometric is iPhone 5s
/// but max 9 ios version is iPhone 4s
const blackListOfUnsupportedBiometricIosDevices = [
  'iPhone4s',
  'iPhone5',
  'iPhone5c'
];

@LazySingleton()
class BiometricDataSource {
  final DeviceInfoPlugin _deviceInfoPlugin;
  final LocalAuthentication _localAuthentication;

  BiometricDataSource(this._localAuthentication, this._deviceInfoPlugin);

  Future<bool> isBiometricIOSDeviceSupported() async {
    final iosInfo = await _deviceInfoPlugin.iosInfo;
    final model = iosInfo.utsname.machine ?? '';
    final isNotSupported = blackListOfUnsupportedBiometricIosDevices
        .every((element) => element.contains(model));

    return !isNotSupported;
  }

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
