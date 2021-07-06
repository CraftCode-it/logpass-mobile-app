import 'package:logpass_me/domain/common/clearable.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device.dart';

abstract class PushNotificationDeviceStore implements Clearable {
  Future<void> save(PushNotificationDevice device);

  Future<PushNotificationDevice?> load();
}
