import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
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

  test('it calls with success', () async {

    when(pushNotificationsRepository.markNotificationAsReceived(notificationId)).thenAnswer((_) async {});

    await markFirebaseNotificationAsReceivedUseCase(notificationId);

    verify(pushNotificationsRepository.markNotificationAsReceived(notificationId)).called(1);
  });

  test('it throws error on failure', () async {
    final expected = Error();

    when(pushNotificationsRepository.markNotificationAsReceived(notificationId)).thenAnswer((_) => throw expected);

    expect(markFirebaseNotificationAsReceivedUseCase(notificationId), throwsA(expected));
  });
}