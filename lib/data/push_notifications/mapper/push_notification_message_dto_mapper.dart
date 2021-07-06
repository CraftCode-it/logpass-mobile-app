import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/data/push_notifications/api/dto/push_notification_message_dto.dart';
import 'package:logpass_me/data/push_notifications/mapper/push_notification_data/push_notification_authorize_dto_mapper.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_message.dart';

@injectable
class PushNotificationMessageDTOMapper implements DataMapper<PushNotificationMessageDTO, PushNotificationMessage> {
  final PushNotificationAuthorizeDTOMapper _pushNotificationAuthorizeDTOMapper;

  PushNotificationMessageDTOMapper(this._pushNotificationAuthorizeDTOMapper);

  @override
  PushNotificationMessage call(PushNotificationMessageDTO data) {
    return data.map(
      authorize: (data) => PushNotificationMessage.authorize(_pushNotificationAuthorizeDTOMapper(data.body)),
      unknown: (data) => PushNotificationMessage.unknown(data.action),
    );
  }
}
