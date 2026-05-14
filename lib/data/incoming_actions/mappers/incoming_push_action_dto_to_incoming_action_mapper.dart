import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/data/push_notifications/api/dto/push_notification_message_dto.dart';
import 'package:logpass_me/domain/incoming_actions/action_type.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';

@injectable
class IncomingPushActionDTOToIncomingActionMapper implements DataMapper<PushNotificationMessageDTO, IncomingAction?> {
  @override
  IncomingAction? call(PushNotificationMessageDTO message) {
    return message.maybeMap(
      authorize: (data) => IncomingAction.create(
        ActionType.authorize(),
        data.body.id,
        message.sendAttemptId,
        null,
      ),
      unknown: (data) {
        // Handle logpass_verify push notifications that arrive via FCM
        // when the WebSocket session is not active (app in background/killed).
        if (data.action == 'logpass_verify') {
          return IncomingAction.create(
            ActionType.logpassVerify(),
            null,
            data.sendAttemptId,
            {'request_type': 'age_18', 'min_age': '18', 'allow_guardian': 'false'},
          );
        }
        return null;
      },
      orElse: () => null,
    );
  }
}
