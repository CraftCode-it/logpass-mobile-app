import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device_store.dart';
import 'package:logpass_me/domain/push_notifications/push_notifications_repository.dart';

@injectable
class UnregisterPushNotificationDeviceUseCase {
  final PushNotificationDeviceStore _pushNotificationDeviceStore;
  final PushNotificationsRepository _pushNotificationsRepository;

  UnregisterPushNotificationDeviceUseCase(
    this._pushNotificationsRepository,
    this._pushNotificationDeviceStore,
  );

  Future<void> call() async {
    final device = await _pushNotificationDeviceStore.load();

    if (device == null) return;

    await _pushNotificationsRepository.deactivateDevice(device.id);
  }
}
