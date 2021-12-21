import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/data/push_notifications/api/dto/push_notification_message_dto.dart';
import 'package:logpass_me/domain/incoming_actions/action_type.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';

@injectable
class IncomingPushActionDTOToIncomingActionMapper implements DataMapper<PushNotificationMessageDTO, IncomingAction?> {
  @override
  IncomingAction? call(PushNotificationMessageDTO message) {

    final action =  message.maybeMap(
      authorize: (data) => IncomingAction.create(ActionType.authorize(), data.body.id, message.sendAttemptId, null),
      orElse: () => null,
    );
    return action;
  }
}
