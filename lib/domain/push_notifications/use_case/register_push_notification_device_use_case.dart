import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device_store.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device_type.dart';
import 'package:logpass_me/domain/push_notifications/push_notifications_repository.dart';

@injectable
class RegisterPushNotificationDeviceUseCase {
  final PushNotificationsRepository _pushNotificationsRepository;
  final PushNotificationDeviceStore _pushNotificationDeviceStore;

  RegisterPushNotificationDeviceUseCase(
    this._pushNotificationsRepository,
    this._pushNotificationDeviceStore,
  );

  Future<void> call() async {
    final storedDevice = await _pushNotificationDeviceStore.load();
    if (storedDevice == null) {
      final registeredDevice = await _pushNotificationsRepository.registerDevice('Test', PushTokenDeviceType.android);
      await _pushNotificationDeviceStore.save(registeredDevice);
    }
  }
}
