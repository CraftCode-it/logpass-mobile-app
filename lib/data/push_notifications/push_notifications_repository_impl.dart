import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/networking/error/dio_error_resolver.dart';
import 'package:logpass_me/data/push_notifications/api/dto/register_push_notification_device_dto.dart';
import 'package:logpass_me/data/push_notifications/api/dto/update_push_notification_device_dto.dart';
import 'package:logpass_me/data/push_notifications/api/push_notifications_api_data_source.dart';
import 'package:logpass_me/data/push_notifications/mapper/push_notification_device_type_dto_mapper.dart';
import 'package:logpass_me/data/push_notifications/push_notifications_manager.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device_type.dart';
import 'package:logpass_me/domain/push_notifications/push_notifications_repository.dart';

@LazySingleton(as: PushNotificationsRepository)
class PushNotificationsRepositoryImpl implements PushNotificationsRepository {
  final PushNotificationsApiDataSource _pushNotificationsApiDataSource;
  final PushNotificationsManager _pushNotificationsManager;
  final PushNotificationDeviceTypeDTOMapper _pushTokenDeviceTypeDTOMapper;

  PushNotificationsRepositoryImpl(
    this._pushNotificationsApiDataSource,
    this._pushNotificationsManager,
    this._pushTokenDeviceTypeDTOMapper,
  );

  @override
  Future<void> initNotificationsServices() async {
    await _pushNotificationsManager.init();
  }

  @override
  Stream<String> registerTokenChangeListener() {
    return _pushNotificationsManager.listenForRefreshToken();
  }

  Future _handleOpeningMessage() async {
    final message = await _pushNotificationsManager.handleOpeningMessage();

    if (message != null) {
      // TODO: to be handled with deep-linking service
    }
  }

  @override
  Future<String> registerDevice(String deviceName, PushTokenDeviceType deviceType) async {
    final token = await _pushNotificationsManager.getRegistrationRefreshToken();
    if (token == null) throw Exception();

    final type = _pushTokenDeviceTypeDTOMapper.from(deviceType);
    final registerDevice = RegisterPushNotificationDeviceDTO(
      registrationToken: token,
      name: deviceName,
      type: type,
      isActive: true,
    );

    await callWithDioErrorResolver(
      () => _pushNotificationsApiDataSource.registerDevice(registerDevice),
    );

    return token;
  }

  @override
  Future<void> deactivateDevice(String token) async {
    await callWithDioErrorResolver(
      () => _pushNotificationsApiDataSource.unregisterDevice(token),
    );
  }

  @override
  Future<void> updateDevice(PushNotificationDevice updatedDevice) async {
    final type = _pushTokenDeviceTypeDTOMapper.from(updatedDevice.type);
    final updateDevice = UpdatePushNotificationDeviceDTO(
      type: type,
      name: updatedDevice.name,
      isActive: updatedDevice.isActive,
    );

    await callWithDioErrorResolver(
      () => _pushNotificationsApiDataSource.updateDevice(updatedDevice.id, updateDevice),
    );
  }

  @override
  Future<void> clear() async {}
}
