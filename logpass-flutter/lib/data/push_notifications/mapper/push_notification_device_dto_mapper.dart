import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/data/push_notifications/api/dto/push_notification_device_dto.dart';
import 'package:logpass_me/data/push_notifications/mapper/push_notification_device_type_dto_mapper.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device.dart';

@injectable
class PushNotificationDeviceFromDTOMapper implements DataMapper<PushNotificationDeviceDTO, PushNotificationDevice> {
  final PushNotificationDeviceTypeDTOMapper _pushNotificationDeviceTypeDTOMapper;

  PushNotificationDeviceFromDTOMapper(this._pushNotificationDeviceTypeDTOMapper);

  @override
  PushNotificationDevice call(PushNotificationDeviceDTO data) {
    return PushNotificationDevice(
      id: data.id,
      name: data.name,
      type: _pushNotificationDeviceTypeDTOMapper.to(data.type),
      isActive: data.isActive,
      webSocketUrl: data.links.websocket
    );
  }
}
