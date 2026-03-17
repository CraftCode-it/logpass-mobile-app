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
  @JsonKey(name: '_links')
  final LinksDTO links;

  PushNotificationDeviceDTO({
    required this.id,
    required this.name,
    required this.type,
    required this.isActive,
    required this.links
  });

  Map<String, dynamic> toJson() => _$PushNotificationDeviceDTOToJson(this);

  factory PushNotificationDeviceDTO.fromJson(Map<String, dynamic> json) => _$PushNotificationDeviceDTOFromJson(json);
}

@JsonSerializable()
class LinksDTO {
  final String websocket;

  LinksDTO({
    required this.websocket,
  });

  Map<String, dynamic> toJson() => _$LinksDTOToJson(this);

  factory LinksDTO.fromJson(Map<String, dynamic> json) => _$LinksDTOFromJson(json);
}