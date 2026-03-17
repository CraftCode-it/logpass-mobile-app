import 'package:logpass_me/domain/device/device.dart';
import 'package:logpass_me/domain/model/device_type.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';

extension Icon on Device {
  String getIconPath() {
    switch (deviceType) {
      case DeviceType.mobile:
        return AppIcon.platformMobile;
      case DeviceType.pc:
        return AppIcon.platformPc;
      case DeviceType.tablet:
        return AppIcon.platformTablet;
      case DeviceType.unknown:
        return AppIcon.device;
    }
  }
}
