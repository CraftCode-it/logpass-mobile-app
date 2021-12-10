import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device_store.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device_type.dart';
import 'package:logpass_me/domain/push_notifications/use_case/get_push_notification_device_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'register_push_notification_device_use_case_test.mocks.dart';

@GenerateMocks(
  [
    PushNotificationDeviceStore,
  ],
)
void main() {
  late PushNotificationDeviceStore pushNotificationDeviceStore;
  late GetNotificationDeviceUseCase getNotificationDeviceUseCase;

  setUp(() {
    pushNotificationDeviceStore = MockPushNotificationDeviceStore();
    getNotificationDeviceUseCase = GetNotificationDeviceUseCase(pushNotificationDeviceStore);
  });

  test('getting notification device executes with success', () async {

    final device = PushNotificationDevice(
        id: 'id',
        isActive: false,
        type: PushTokenDeviceType.ios,
        name: 'name',
        webSocketUrl: 'url'
    );

    when(pushNotificationDeviceStore.load()).thenAnswer((_) async => device);

    final result = await getNotificationDeviceUseCase();

    verify(pushNotificationDeviceStore.load());
    expect(result, device);
  });

  test('throws error during getting notification device', () async {
    final expected = Error();

    when(pushNotificationDeviceStore.load()).thenAnswer((_) => throw expected);

    expect(() => getNotificationDeviceUseCase(), throwsA(expected));
  });

  test('throws error when getting device result is null', () async {
    final expected = Error();

    when(pushNotificationDeviceStore.load()).thenAnswer((_) async => null);
    when(await pushNotificationDeviceStore.load() == null).thenAnswer((_) => throw expected);

    expect(() => getNotificationDeviceUseCase(), throwsA(expected));
  });
}