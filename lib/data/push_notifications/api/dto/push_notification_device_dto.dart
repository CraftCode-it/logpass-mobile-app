import 'package:json_annotation/json_annotation.dart';

part 'push_notification_device_dto.g.dart';

@JsonSerializable()
class PushNotificationDeviceWrapperDTO {
  final PushNotificationDeviceDTO data;

  PushNotificationDeviceWrapperDTO({
    required this.data,
  });

  Map<String, dynamic> toJson() => _$PushNotificationDeviceWrapperDTOToJson(this);

  factory PushNotificationDeviceWrapperDTO.fromJson(Map<String, dynamic> json) => _$PushNotificationDeviceWrapperDTOFromJson(json);
}

@JsonSerializable()
class PushNotificationDeviceDTO {
  final String id;
  final String name;
  final String type;
  final bool isActive;

  PushNotificationDeviceDTO({
    required this.id,
    required this.name,
    required this.type,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => _$PushNotificationDeviceDTOToJson(this);

  factory PushNotificationDeviceDTO.fromJson(Map<String, dynamic> json) => _$PushNotificationDeviceDTOFromJson(json);
}
