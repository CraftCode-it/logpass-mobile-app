import 'package:json_annotation/json_annotation.dart';

part 'register_push_notification_device_dto.g.dart';

@JsonSerializable()
class RegisterPushNotificationDeviceDTO {
  final String registrationToken;
  final String name;
  final String type;
  final bool isActive;

  RegisterPushNotificationDeviceDTO({
    required this.registrationToken,
    required this.name,
    required this.type,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => _$RegisterPushNotificationDeviceDTOToJson(this);

  factory RegisterPushNotificationDeviceDTO.fromJson(Map<String, dynamic> json) =>
      _$RegisterPushNotificationDeviceDTOFromJson(json);
}
