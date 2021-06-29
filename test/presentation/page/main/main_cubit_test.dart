import 'package:bloc_test/bloc_test.dart' hide when, verify;
import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/incoming_actions/action_type.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/get_queued_incoming_action_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/subscribe_to_incoming_actions_from_link_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/subscribe_to_incoming_actions_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/switch_pre_login_action_handler_use_case.dart';
import 'package:logpass_me/domain/push_notifications/use_case/init_notifications_services_use_case.dart';
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
    SubscribeToIncomingActionsUseCase,
    InitNotificationsServicesUseCase,
    SwitchPreLoginActionHandlerUseCase,
    SubscribeToIncomingActionsFromLinkUseCase,
    GetQueuedIncomingActionUseCase,
  ],
)
void main() {
  late SetupWebSocketChannelUseCase setupWebSocketChannelUseCase;
  late CloseWebSocketUseCase closeWebSocketUseCase;
  late SubscribeToIncomingActionsUseCase subscribeToIncomingActionsUseCase;
  late InitNotificationsServicesUseCase initNotificationsServicesUseCase;
  late SwitchPreLoginActionHandlerUseCase switchPreLoginActionHandlerUseCase;
  late SubscribeToIncomingActionsFromLinkUseCase subscribeToIncomingActionsFromLinkUseCase;
  late GetQueuedIncomingActionUseCase getQueuedIncomingActionUseCase;
  late MainPageCubit cubit;

  setUp(() {
    setupWebSocketChannelUseCase = MockSetupWebSocketChannelUseCase();
    closeWebSocketUseCase = MockCloseWebSocketUseCase();
    subscribeToIncomingActionsUseCase = MockSubscribeToIncomingActionsUseCase();
    initNotificationsServicesUseCase = MockInitNotificationsServicesUseCase();
    switchPreLoginActionHandlerUseCase = MockSwitchPreLoginActionHandlerUseCase();
    subscribeToIncomingActionsFromLinkUseCase = MockSubscribeToIncomingActionsFromLinkUseCase();
    getQueuedIncomingActionUseCase = MockGetQueuedIncomingActionUseCase();

    cubit = MainPageCubit(
      setupWebSocketChannelUseCase,
      subscribeToIncomingActionsUseCase,
      closeWebSocketUseCase,
      initNotificationsServicesUseCase,
      switchPreLoginActionHandlerUseCase,
      subscribeToIncomingActionsFromLinkUseCase,
      getQueuedIncomingActionUseCase,
    );
  });

  group('initialize', () {
    final incomingAction = IncomingAction(ActionType.authorize(), 'link');
    const failureMessage = 'Error message';

    blocTest<MainPageCubit, MainPageState>(
      'emits [ShowAction] on received stream value',
      build: () {
        when(setupWebSocketChannelUseCase()).thenAnswer((invocation) async => {});
        when(subscribeToIncomingActionsUseCase()).thenAnswer((invocation) => Stream.value(incomingAction));

        return cubit;
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        MainPageState.showAction(incomingAction),
      ],
    );

    blocTest<MainPageCubit, MainPageState>(
      'emits [Error] on WS channel setup failure',
      build: () {
        final expect = Exception();
        when(setupWebSocketChannelUseCase()).thenAnswer((invocation) async => throw expect);
        when(subscribeToIncomingActionsUseCase()).thenAnswer((invocation) => throw expect);

        return cubit;
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        const MainPageState.error(failureMessage),
      ],
    );
  });
}
