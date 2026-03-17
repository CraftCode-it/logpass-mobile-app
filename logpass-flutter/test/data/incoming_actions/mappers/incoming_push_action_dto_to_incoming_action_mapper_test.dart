import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/data/incoming_actions/mappers/incoming_push_action_dto_to_incoming_action_mapper.dart';
import 'package:logpass_me/data/push_notifications/api/dto/push_notification_data/push_notification_authorize_dto.dart';
import 'package:logpass_me/data/push_notifications/api/dto/push_notification_message_dto.dart';
import 'package:logpass_me/domain/incoming_actions/action_type.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';

void main() {
  late IncomingPushActionDTOToIncomingActionMapper mapper;

  setUp(() {
    mapper = IncomingPushActionDTOToIncomingActionMapper();
  });

  test('returns mapped authorize action', () {
    final dto = PushNotificationMessageDTO.authorize('sendAttemptId', PushNotificationAuthorizeDTO('id'));
    final expected = IncomingAction.create(ActionType.authorize(), 'id', 'sendAttemptId', null);

    final result = mapper(dto);

    expect(expected, result);
  });

  test('returns null if unsupported action', () {
    final dto = PushNotificationMessageDTO.unknown('sendAttemptId', 'unsupported');
    final action = mapper(dto);

    expect(action, null);
  });
}
