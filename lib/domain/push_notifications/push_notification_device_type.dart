import 'dart:io';

import 'package:injectable/injectable.dart';

enum PushTokenDeviceType { android, ios }

@injectable
class PushTokenDeviceTypeFactory {
  PushTokenDeviceType get() {
    if (Platform.isAndroid) {
      return PushTokenDeviceType.android;
    } else if (Platform.isIOS) {
      return PushTokenDeviceType.ios;
    } else {
      throw UnsupportedError('This kind of platform is not supported');
    }
  }
}