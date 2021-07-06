import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/device_info/device_info_repository.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device_store.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device_type.dart';
import 'package:logpass_me/domain/push_notifications/push_notifications_repository.dart';

@injectable
class RegisterPushNotificationDeviceUseCase {
  final PushNotificationsRepository _pushNotificationsRepository;
  final PushNotificationDeviceStore _pushNotificationDeviceStore;
  final DeviceInfoRepository _deviceInfoRepository;

  RegisterPushNotificationDeviceUseCase(
    this._pushNotificationsRepository,
    this._pushNotificationDeviceStore,
    this._deviceInfoRepository,
  );

  Future<void> call() async {
    final storedDevice = await _pushNotificationDeviceStore.load();

    if (storedDevice == null) {
      await _registerDevice();
    } else {
      final currentToken = await _pushNotificationsRepository.getToken();

      if (currentToken != null && currentToken != storedDevice.id) {
        await _pushNotificationsRepository.deactivateDevice(storedDevice.id);
        await _registerDevice();
      }
    }
  }

  Future<void> _registerDevice() async {
    final registeredDevice = await _pushNotificationsRepository.registerDevice(
      await _deviceInfoRepository.getDeviceName(),
      _getDeviceType(),
    );
    await _pushNotificationDeviceStore.save(registeredDevice);
  }

  PushTokenDeviceType _getDeviceType() {
    if (Platform.isAndroid) {
      return PushTokenDeviceType.android;
    } else if (Platform.isIOS) {
      return PushTokenDeviceType.ios;
    } else {
      throw UnsupportedError('This kind of platform is not supported');
    }
  }
}
