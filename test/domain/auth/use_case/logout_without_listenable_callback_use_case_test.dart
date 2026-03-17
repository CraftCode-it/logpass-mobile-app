import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/auth/logout_service.dart';
import 'package:logpass_me/domain/auth/use_case/logout_without_listenable_callback_use_case.dart';
import 'package:logpass_me/domain/push_notifications/use_case/unregister_push_notification_device_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'logout_without_listenable_callback_use_case_test.mocks.dart';

@GenerateMocks(
  [
    LogoutService,
    UnregisterPushNotificationDeviceUseCase,
  ],
)
void main() {
  late LogoutService logoutService;
  late UnregisterPushNotificationDeviceUseCase unregisterPushNotificationDeviceUseCase;

  late LogoutWithoutListenableCallbackUseCase useCase;

  setUp(() {
    logoutService = MockLogoutService();
    unregisterPushNotificationDeviceUseCase = MockUnregisterPushNotificationDeviceUseCase();
    useCase = LogoutWithoutListenableCallbackUseCase(logoutService, unregisterPushNotificationDeviceUseCase);
  });

  test('verify logout service and unregister push notification use case', () async {

    when(logoutService.logoutWithoutListenableCallback()).thenAnswer((_) async => Future.value(null));
    when(unregisterPushNotificationDeviceUseCase()).thenAnswer((_) async => Future.value(null));

    await useCase();
    verify(logoutService.logoutWithoutListenableCallback()).called(1);
    verify(unregisterPushNotificationDeviceUseCase()).called(1);
  });

  test('it throws error during logout', () {
    final expected = Error();

    when(logoutService.logoutWithoutListenableCallback()).thenAnswer((_) => throw expected);

    expect(useCase(), throwsA(expected));
  });

  test('it throws error during unregistering push notification', () {
    final expected = Error();

    when(unregisterPushNotificationDeviceUseCase()).thenAnswer((_) => throw expected);

    expect(useCase(), throwsA(expected));
  });
}
