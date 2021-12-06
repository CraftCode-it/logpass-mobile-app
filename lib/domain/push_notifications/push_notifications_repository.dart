import 'package:logpass_me/domain/push_notifications/push_notification_device.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device_type.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_message.dart';

abstract class PushNotificationsRepository {
  Future<void> initNotificationsServices();

  Stream<String> registerTokenChangeListener();

  Future<PushNotificationMessage?> initialMessage();

  Stream<PushNotificationMessage> registerMessageListener();

  Future<PushNotificationDevice> registerDevice(String deviceName, PushTokenDeviceType deviceType);

  Future<String?> getToken();

  Future<void> deactivateDevice(String token);

  Future<void> updateDevice(PushNotificationDevice updatedDevice);

  Future<void> markNotificationAsReceived(String notificationId);
}
