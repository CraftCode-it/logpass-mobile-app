import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_notification_device_entity.g.dart';

@JsonSerializable()
class PushNotificationDeviceEntity {
  final String id;
  final String name;
  final String type;
  final bool isActive;
  final String webSocketUrl;

  PushNotificationDeviceEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.isActive,
    required this.webSocketUrl,
  });

  Map<String, dynamic> toJson() => _$PushNotificationDeviceEntityToJson(this);

  factory PushNotificationDeviceEntity.fromJson(Map<String, dynamic> json) => _$PushNotificationDeviceEntityFromJson(json);
}
