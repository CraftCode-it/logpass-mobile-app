import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/incoming_actions/action_type.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/push_notifications/push_notifications_repository.dart';
import 'package:logpass_me/domain/push_notifications/use_case/mark_firebase_notification_as_received_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mark_firebase_notification_as_received_use_case_test.mocks.dart';

@GenerateMocks(
  [
    PushNotificationsRepository,
  ],
)
void main() {
  late PushNotificationsRepository pushNotificationsRepository;
  late MarkFirebaseNotificationAsReceivedUseCase markFirebaseNotificationAsReceivedUseCase;

  setUp(() {
    pushNotificationsRepository = MockPushNotificationsRepository();
    markFirebaseNotificationAsReceivedUseCase = MarkFirebaseNotificationAsReceivedUseCase(pushNotificationsRepository);
  });

  const notificationId = 'id';
  final expirationTime = DateTime(2021, 12, 6);

  test('it executes when id is not null and notification is from firebase', () async {
    final action = IncomingAction.createFromFirebase(ActionType.authorize(), 'id', null);

    when(pushNotificationsRepository.markNotificationAsReceived(notificationId)).thenAnswer((_) async {});

    await markFirebaseNotificationAsReceivedUseCase(action);

    verify(pushNotificationsRepository.markNotificationAsReceived(notificationId)).called(1);
  });

  test('it does not execute when id is not null and notification is not from firebase', () async {
    final action = IncomingAction.createFromWebSocket(ActionType.authorize(), 'id', null);

    when(pushNotificationsRepository.markNotificationAsReceived(notificationId)).thenAnswer((_) async {});

    await markFirebaseNotificationAsReceivedUseCase(action);

    verifyNever(pushNotificationsRepository.markNotificationAsReceived(notificationId));
  });

  test('it does not execute when id is null and notification is not from firebase', () async {
    final action = IncomingAction.createFromWebSocket(ActionType.authorize(), null, null);

    when(pushNotificationsRepository.markNotificationAsReceived(notificationId)).thenAnswer((_) async {});

    await markFirebaseNotificationAsReceivedUseCase(action);

    verifyNever(pushNotificationsRepository.markNotificationAsReceived(notificationId));
  });

  test('it does not execute when id is null but notification is from firebase', () async {
    final action = IncomingAction.createFromFirebase(ActionType.authorize(), null, null);

    when(pushNotificationsRepository.markNotificationAsReceived(notificationId)).thenAnswer((_) async {});

    await markFirebaseNotificationAsReceivedUseCase(action);

    verifyNever(pushNotificationsRepository.markNotificationAsReceived(notificationId));
  });

  test('it throws error during executing when action is from firebase', () async {
    final action = IncomingAction.createFromFirebase(ActionType.authorize(), 'id', null);
    final expected = Error();

    when(pushNotificationsRepository.markNotificationAsReceived(notificationId)).thenAnswer((_) => throw expected);

    expect(markFirebaseNotificationAsReceivedUseCase(action), throwsA(expected));
  });
}