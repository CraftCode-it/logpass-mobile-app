import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/bidirectional_data_mapper.dart';
import 'package:logpass_me/data/push_notifications/database/entity/push_notification_device_entity.dart';
import 'package:logpass_me/data/push_notifications/mapper/push_notification_device_type_entity_mapper.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device.dart';

@injectable
class PushNotificationDeviceEntityMapper
    implements BidirectionalDataMapper<PushNotificationDevice, PushNotificationDeviceEntity> {
  final PushNotificationDeviceTypeEntityMapper _deviceTypeEntityMapper;

  PushNotificationDeviceEntityMapper(this._deviceTypeEntityMapper);

  @override
  PushNotificationDeviceEntity from(PushNotificationDevice data) {
    return PushNotificationDeviceEntity(
      id: data.id,
      name: data.name,
      type: _deviceTypeEntityMapper.from(data.type),
      isActive: data.isActive,
      webSocketUrl: data.webSocketUrl
    );
  }

  @override
  PushNotificationDevice to(PushNotificationDeviceEntity data) {
    return PushNotificationDevice(
      id: data.id,
      name: data.name,
      type: _deviceTypeEntityMapper.to(data.type),
      isActive: data.isActive,
      webSocketUrl: data.webSocketUrl
    );
  }
}
