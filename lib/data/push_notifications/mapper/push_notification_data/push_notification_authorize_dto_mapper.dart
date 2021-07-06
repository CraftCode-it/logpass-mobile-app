import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/data/push_notifications/api/dto/push_notification_data/push_notification_authorize_dto.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_data/push_notification_authorize_data.dart';

@injectable
class PushNotificationAuthorizeDTOMapper
    implements DataMapper<PushNotificationAuthorizeDTO, PushNotificationAuthorizeData> {
  @override
  PushNotificationAuthorizeData call(PushNotificationAuthorizeDTO data) {
    return PushNotificationAuthorizeData(id: data.id);
  }
}
