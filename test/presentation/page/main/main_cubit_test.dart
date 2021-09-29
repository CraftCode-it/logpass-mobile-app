import 'package:bloc_test/bloc_test.dart' hide when, verify;
import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/incoming_actions/action_type.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/get_queued_incoming_action_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/subscribe_to_incoming_actions_from_background_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/subscribe_to_incoming_actions_from_link_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/switch_pre_login_action_handler_use_case.dart';
import 'package:logpass_me/domain/push_notifications/use_case/init_notifications_services_use_case.dart';
import 'package:logpass_me/domain/push_notifications/use_case/register_push_notification_device_use_case.dart';
import 'package:logpass_me/domain/web_socket/use_case/close_web_socket_use_case.dart';
import 'package:logpass_me/domain/web_socket/use_case/setup_web_socket_channel_use_case.dart';
import 'package:logpass_me/presentation/page/main/main_page_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'main_cubit_test.mocks.dart';

@GenerateMocks(
  [
    SetupWebSocketChannelUseCase,
    CloseWebSocketUseCase,
    InitNotificationsServicesUseCase,
    SwitchPreLoginActionHandlerUseCase,
    SubscribeToIncomingActionsFromLinkUseCase,
    GetQueuedIncomingActionUseCase,
    RegisterPushNotificationDeviceUseCase,
    SubscribeToIncomingActionsFromBackgroundUseCase
  ],
)
void main() {
  late SetupWebSocketChannelUseCase setupWebSocketChannelUseCase;
  late CloseWebSocketUseCase closeWebSocketUseCase;
  late InitNotificationsServicesUseCase initNotificationsServicesUseCase;
  late SwitchPreLoginActionHandlerUseCase switchPreLoginActionHandlerUseCase;
  late SubscribeToIncomingActionsFromLinkUseCase subscribeToIncomingActionsFromLinkUseCase;
  late GetQueuedIncomingActionUseCase getQueuedIncomingActionUseCase;
  late RegisterPushNotificationDeviceUseCase registerPushNotificationDeviceUseCase;
  late SubscribeToIncomingActionsFromBackgroundUseCase subscribeToIncomingActionsFromBackgroundUseCase;
  late MainPageCubit cubit;

  setUp(() {
    setupWebSocketChannelUseCase = MockSetupWebSocketChannelUseCase();
    closeWebSocketUseCase = MockCloseWebSocketUseCase();
    initNotificationsServicesUseCase = MockInitNotificationsServicesUseCase();
    switchPreLoginActionHandlerUseCase = MockSwitchPreLoginActionHandlerUseCase();
    subscribeToIncomingActionsFromLinkUseCase = MockSubscribeToIncomingActionsFromLinkUseCase();
    getQueuedIncomingActionUseCase = MockGetQueuedIncomingActionUseCase();
    registerPushNotificationDeviceUseCase = MockRegisterPushNotificationDeviceUseCase();
    subscribeToIncomingActionsFromBackgroundUseCase = MockSubscribeToIncomingActionsFromBackgroundUseCase();

    cubit = MainPageCubit(
      setupWebSocketChannelUseCase,
      closeWebSocketUseCase,
      initNotificationsServicesUseCase,
      switchPreLoginActionHandlerUseCase,
      subscribeToIncomingActionsFromLinkUseCase,
      getQueuedIncomingActionUseCase,
      registerPushNotificationDeviceUseCase,
      subscribeToIncomingActionsFromBackgroundUseCase,
    );
  });

  group('initialize', () {
    final incomingAction = IncomingAction(ActionType.authorize(), 'link', {'key': 'value'});
    const failureMessage = 'Error message';

    blocTest<MainPageCubit, MainPageState>(
      'emits [Error] on WS channel setup failure',
      build: () {
        final expect = Exception();
        when(setupWebSocketChannelUseCase()).thenAnswer((invocation) async => throw expect);

        return cubit;
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        const MainPageState.error(failureMessage),
      ],
    );

    blocTest<MainPageCubit, MainPageState>(
      'emits [OpenAction] when there is queued incoming action',
      build: () {
        when(setupWebSocketChannelUseCase()).thenAnswer((invocation) async => {});
        when(getQueuedIncomingActionUseCase()).thenAnswer((realInvocation) async => incomingAction);
        when(subscribeToIncomingActionsFromLinkUseCase()).thenAnswer((realInvocation) => const Stream.empty());

        return cubit;
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        MainPageState.openAction(incomingAction),
      ],
    );

    blocTest<MainPageCubit, MainPageState>(
      'emits [OpenAction] when incoming action from link emits event',
      build: () {
        when(setupWebSocketChannelUseCase()).thenAnswer((invocation) async => {});
        when(getQueuedIncomingActionUseCase()).thenAnswer((realInvocation) async => null);
        when(subscribeToIncomingActionsFromLinkUseCase()).thenAnswer((realInvocation) => Stream.value(incomingAction));

        return cubit;
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        MainPageState.openAction(incomingAction),
      ],
    );

    blocTest<MainPageCubit, MainPageState>(
      'emits nothing',
      build: () {
        when(setupWebSocketChannelUseCase()).thenAnswer((invocation) async => {});
        when(getQueuedIncomingActionUseCase()).thenAnswer((realInvocation) async => null);
        when(subscribeToIncomingActionsFromLinkUseCase()).thenAnswer((realInvocation) => const Stream.empty());

        return cubit;
      },
      act: (cubit) => cubit.init(),
      expect: () => [],
    );
  });
}
