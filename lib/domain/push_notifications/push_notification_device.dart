import 'package:logpass_me/domain/push_notifications/push_notification_device_type.dart';

class PushNotificationDevice {
  final String id;
  final String name;
  final PushTokenDeviceType type;
  final bool isActive;

  PushNotificationDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.isActive,
  });
}
