import 'package:logpass_me/domain/push_notifications/push_notification_device_type.dart';

class PushNotificationDevice {
  final String id;
  final String name;
  final PushTokenDeviceType type;
  final bool isActive;
  final String webSocketUrl;

  PushNotificationDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.isActive,
    required this.webSocketUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PushNotificationDevice &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          type == other.type &&
          webSocketUrl == other.webSocketUrl &&
          isActive == other.isActive;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ type.hashCode ^ isActive.hashCode ^webSocketUrl.hashCode;
}
