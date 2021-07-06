import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/device_info/device_info_repository.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device_store.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device_type.dart';
import 'package:logpass_me/domain/push_notifications/push_notifications_repository.dart';
import 'package:logpass_me/domain/push_notifications/use_case/register_push_notification_device_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'register_push_notification_device_use_case_test.mocks.dart';

@GenerateMocks(
  [
    PushNotificationsRepository,
    PushNotificationDeviceStore,
    DeviceInfoRepository,
    PushTokenDeviceTypeFactory,
  ],
)
void main() {
  late MockPushNotificationsRepository pushNotificationsRepository;
  late MockPushNotificationDeviceStore pushNotificationDeviceStore;
  late MockDeviceInfoRepository deviceInfoRepository;
  late MockPushTokenDeviceTypeFactory pushTokenDeviceTypeFactory;

  late RegisterPushNotificationDeviceUseCase useCase;

  setUp(() {
    pushNotificationsRepository = MockPushNotificationsRepository();
    pushNotificationDeviceStore = MockPushNotificationDeviceStore();
    deviceInfoRepository = MockDeviceInfoRepository();
    pushTokenDeviceTypeFactory = MockPushTokenDeviceTypeFactory();
    useCase = RegisterPushNotificationDeviceUseCase(
      pushNotificationsRepository,
      pushNotificationDeviceStore,
      deviceInfoRepository,
      pushTokenDeviceTypeFactory,
    );
  });

  test('it completes without action when device is stored and token did not change', () async {
    const deviceName = 'Pixel 4a';
    const deviceType = PushTokenDeviceType.android;
    const token = '000-aaa-bbb';

    final device = PushNotificationDevice(
      id: token,
      name: deviceName,
      type: deviceType,
      isActive: true,
    );

    when(deviceInfoRepository.getDeviceName()).thenAnswer((realInvocation) async => deviceName);
    when(pushTokenDeviceTypeFactory.get()).thenAnswer((realInvocation) => deviceType);
    when(pushNotificationDeviceStore.load()).thenAnswer((realInvocation) async => device);
    when(pushNotificationsRepository.getToken()).thenAnswer((realInvocation) async => token);

    await useCase();

    verifyNever(pushNotificationsRepository.registerDevice(any, any));
    verifyNever(pushNotificationDeviceStore.save(any));
  });

  test('it registers and saves device when device is not stored', () async {
    const deviceName = 'Pixel 4a';
    const deviceType = PushTokenDeviceType.android;

    final device = PushNotificationDevice(
      id: '000-aaa-bbb',
      name: deviceName,
      type: deviceType,
      isActive: true,
    );

    when(pushNotificationDeviceStore.load()).thenAnswer((realInvocation) async => null);
    when(pushNotificationsRepository.registerDevice(deviceName, deviceType))
        .thenAnswer((realInvocation) async => device);
    when(deviceInfoRepository.getDeviceName()).thenAnswer((realInvocation) async => deviceName);
    when(pushTokenDeviceTypeFactory.get()).thenAnswer((realInvocation) => deviceType);

    await useCase();

    verify(pushNotificationsRepository.registerDevice(deviceName, deviceType));
    verify(pushNotificationDeviceStore.save(device));
  });

  test('it clears store and saves new device when token did change', () async {
    const deviceName = 'Pixel 4a';
    const deviceType = PushTokenDeviceType.android;
    const newToken = '000-aaa-bbb';

    final oldDevice = PushNotificationDevice(
      id: '000-aaa-aaa',
      name: deviceName,
      type: deviceType,
      isActive: true,
    );

    final device = PushNotificationDevice(
      id: newToken,
      name: deviceName,
      type: deviceType,
      isActive: true,
    );

    when(pushNotificationDeviceStore.load()).thenAnswer((realInvocation) async => oldDevice);
    when(pushNotificationsRepository.registerDevice(deviceName, deviceType))
        .thenAnswer((realInvocation) async => device);
    when(deviceInfoRepository.getDeviceName()).thenAnswer((realInvocation) async => deviceName);
    when(pushTokenDeviceTypeFactory.get()).thenAnswer((realInvocation) => deviceType);
    when(pushNotificationsRepository.getToken()).thenAnswer((realInvocation) async => newToken);

    await useCase();

    verify(pushNotificationsRepository.deactivateDevice(oldDevice.id));
    verify(pushNotificationsRepository.registerDevice(deviceName, deviceType));
    verify(pushNotificationDeviceStore.save(device));
  });
}
