import 'package:logpass_me/domain/common/clearable.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device_type.dart';

abstract class PushNotificationsRepository implements Clearable {
  Future<void> initNotificationsServices();

  Stream<String> registerTokenChangeListener();

  Future<String> registerDevice(String deviceName, PushTokenDeviceType deviceType);

  Future<void> deactivateDevice(String token);

  Future<void> updateDevice(PushNotificationDevice updatedDevice);
}
