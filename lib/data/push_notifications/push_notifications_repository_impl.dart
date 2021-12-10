import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:logpass_me/data/networking/error/dio_error_resolver.dart';
import 'package:logpass_me/data/push_notifications/api/dto/mark_push_notification_received_dto.dart';
import 'package:logpass_me/data/push_notifications/api/dto/register_push_notification_device_dto.dart';
import 'package:logpass_me/data/push_notifications/api/dto/update_push_notification_device_dto.dart';
import 'package:logpass_me/data/push_notifications/api/push_notifications_api_data_source.dart';
import 'package:logpass_me/data/push_notifications/mapper/push_notification_device_dto_mapper.dart';
import 'package:logpass_me/data/push_notifications/mapper/push_notification_device_type_dto_mapper.dart';
import 'package:logpass_me/data/push_notifications/mapper/push_notification_message_dto_mapper.dart';
import 'package:logpass_me/data/push_notifications/push_notifications_manager.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device_type.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_message.dart';
import 'package:logpass_me/domain/push_notifications/push_notifications_repository.dart';

const timeFormat = 'yyyy-MM-ddTHH:mm:ssZ';

@LazySingleton(as: PushNotificationsRepository)
class PushNotificationsRepositoryImpl implements PushNotificationsRepository {
  final PushNotificationsApiDataSource _pushNotificationsApiDataSource;
  final PushNotificationsManager _pushNotificationsManager;
  final PushNotificationDeviceTypeDTOMapper _pushTokenDeviceTypeDTOMapper;
  final PushNotificationDeviceFromDTOMapper _pushNotificationDeviceFromDTOMapper;
  final PushNotificationMessageDTOMapper _pushNotificationMessageDTOMapper;

  PushNotificationsRepositoryImpl(
    this._pushNotificationsApiDataSource,
    this._pushNotificationsManager,
    this._pushTokenDeviceTypeDTOMapper,
    this._pushNotificationDeviceFromDTOMapper,
    this._pushNotificationMessageDTOMapper,
  );

  @override
  Future<void> initNotificationsServices() async {
    await _pushNotificationsManager.init();
  }

  @override
  Stream<String> registerTokenChangeListener() {
    return _pushNotificationsManager.listenForRefreshToken();
  }

  @override
  Future<PushNotificationMessage?> initialMessage() async {
    final message = await _pushNotificationsManager.handleOpeningMessage();
    if (message == null) return null;

    return _pushNotificationMessageDTOMapper(message);
  }

  @override
  Stream<PushNotificationMessage> registerMessageListener() =>
      _pushNotificationsManager.listenForForegroundMessages().map(_pushNotificationMessageDTOMapper);

  @override
  Future<String?> getToken() => _pushNotificationsManager.getRegistrationRefreshToken();

  @override
  Future<PushNotificationDevice> registerDevice(String deviceName, PushTokenDeviceType deviceType) async {
    final token = await _pushNotificationsManager.getRegistrationRefreshToken();
    if (token == null) throw Exception();

    final type = _pushTokenDeviceTypeDTOMapper.from(deviceType);
    final registerDevice = RegisterPushNotificationDeviceDTO(
      registrationToken: token,
      name: deviceName,
      type: type,
      isActive: true,
    );

    //TODO here we get websocket link
    final device = await callWithDioErrorResolver(
      () => _pushNotificationsApiDataSource.registerDevice(registerDevice),
    );

    return _pushNotificationDeviceFromDTOMapper(device.data);
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
  Future<void> markNotificationAsReceived(String notificationId) async {
    final now = DateTime.now();
    final formatter = DateFormat(timeFormat);

    final body = MarkPushNotificationReceivedDTO(formatter.format(now));

    await callWithDioErrorResolver(
      () => _pushNotificationsApiDataSource.markAsReceived(notificationId, body),
    );
  }
}
