import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/domain/model/device_type.dart';

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
