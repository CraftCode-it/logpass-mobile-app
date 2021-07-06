import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/push_notifications/database/entity/push_notification_device_entity.dart';

@lazySingleton
class PushNotificationDeviceDatabase {
  static const _key = 'logPassPushNotification';
  static const _iosOptions = IOSOptions(accessibility: IOSAccessibility.unlocked_this_device);

  final FlutterSecureStorage _storage;

  PushNotificationDeviceDatabase(this._storage);

  Future<void> save(PushNotificationDeviceEntity entity) async {
    final json = jsonEncode(entity.toJson());
    await _storage.write(
      key: _key,
      value: json,
      iOptions: _iosOptions,
    );
  }

  Future<PushNotificationDeviceEntity?> load() async {
    final json = await _storage.read(key: _key, iOptions: _iosOptions);

    if (json == null) return null;

    return PushNotificationDeviceEntity.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> clear() async {
    await _storage.delete(key: _key, iOptions: _iosOptions);
  }
}
