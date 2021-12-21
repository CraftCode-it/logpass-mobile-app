import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/incoming_actions/action_type.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/push_notifications/push_notifications_repository.dart';
import 'package:logpass_me/domain/push_notifications/use_case/mark_notification_as_received_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mark_notification_as_received_use_case_test.mocks.dart';


@GenerateMocks(
  [
    PushNotificationsRepository,
  ],
)
void main() {
  late PushNotificationsRepository pushNotificationsRepository;
  late MarkNotificationAsReceivedUseCase markNotificationAsReceivedUseCase;

  setUp(() {
    pushNotificationsRepository = MockPushNotificationsRepository();
    markNotificationAsReceivedUseCase = MarkNotificationAsReceivedUseCase(pushNotificationsRepository);
  });

  const notificationId = 'sendAttemptId';

  test('it executes when id is not null', () async {
    final action = IncomingAction.create(ActionType.authorize(), 'id', 'sendAttemptId', null);

    when(pushNotificationsRepository.markNotificationAsReceived(notificationId)).thenAnswer((_) async {});

    await markNotificationAsReceivedUseCase(action);

    verify(pushNotificationsRepository.markNotificationAsReceived(notificationId)).called(1);
  });

  test('it does not execute when id is null', () async {
    final action = IncomingAction.create(ActionType.authorize(), null, null, null);

    when(pushNotificationsRepository.markNotificationAsReceived(notificationId)).thenAnswer((_) async {});

    await markNotificationAsReceivedUseCase(action);

    verifyNever(pushNotificationsRepository.markNotificationAsReceived(notificationId));
  });

  test('it throws error during executing', () async {
    final action = IncomingAction.create(ActionType.authorize(), 'id', 'sendAttemptId', null);
    final expected = Error();

    when(pushNotificationsRepository.markNotificationAsReceived(notificationId)).thenAnswer((_) => throw expected);

    expect(markNotificationAsReceivedUseCase(action), throwsA(expected));
  });
}