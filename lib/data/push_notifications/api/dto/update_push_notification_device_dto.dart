import 'package:json_annotation/json_annotation.dart';

part 'update_push_notification_device_dto.g.dart';

@JsonSerializable()
class UpdatePushNotificationDeviceDTO {
  final String name;
  final String type;
  final bool isActive;

  UpdatePushNotificationDeviceDTO({
    required this.name,
    required this.type,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => _$UpdatePushNotificationDeviceDTOToJson(this);

  factory UpdatePushNotificationDeviceDTO.fromJson(Map<String, dynamic> json) =>
      _$UpdatePushNotificationDeviceDTOFromJson(json);
}
