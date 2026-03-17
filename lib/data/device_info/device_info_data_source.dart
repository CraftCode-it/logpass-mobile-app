import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeviceInfoDataSource {
  final DeviceInfoPlugin _deviceInfoPlugin;

  DeviceInfoDataSource(this._deviceInfoPlugin);

  Future<String> getDeviceName() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      return androidInfo.model ?? 'Android';
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      return iosInfo.name ?? 'iOS';
    } else {
      return 'Unknown';
    }
  }
}
