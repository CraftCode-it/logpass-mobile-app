import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/push_notifications/database/push_notification_device_database.dart';
import 'package:logpass_me/data/push_notifications/mapper/push_notification_device_entity_mapper.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device_store.dart';

@LazySingleton(as: PushNotificationDeviceStore)
class SecurePushNotificationDeviceStore implements PushNotificationDeviceStore {
  final PushNotificationDeviceDatabase _database;
  final PushNotificationDeviceEntityMapper _pushNotificationDeviceEntityMapper;

  SecurePushNotificationDeviceStore(this._database, this._pushNotificationDeviceEntityMapper);

  @override
  Future<PushNotificationDevice?> load() async {
    final entity = await _database.load();
    if (entity == null) return null;

    return _pushNotificationDeviceEntityMapper.to(entity);
  }

  @override
  Future<void> save(PushNotificationDevice device) async {
    final entity = _pushNotificationDeviceEntityMapper.from(device);
    await _database.save(entity);
  }

  @override
  Future<void> clear() async {
    await _database.clear();
  }
}
