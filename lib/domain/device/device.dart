import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/domain/model/device_type.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';

part 'device.freezed.dart';

@freezed
class Device with _$Device {
  factory Device({
    required String id,
    required String name,
    required int trustLevel,
    required DeviceType deviceType,
  }) = _Device;
}

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
