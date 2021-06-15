import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/subscribe_to_incoming_actions_use_case.dart';
import 'package:logpass_me/domain/push_notifications/use_case/init_notifications_services_use_case.dart';
import 'package:logpass_me/domain/web_socket/use_case/close_web_socket_use_case.dart';
import 'package:logpass_me/domain/web_socket/use_case/setup_web_socket_channel_use_case.dart';
import 'package:logpass_me/presentation/page/main/main_page_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart' hide when, verify;
import 'package:mockito/mockito.dart';

import 'main_cubit_test.mocks.dart';

@GenerateMocks(
  [
    SetupWebSocketChannelUseCase,
    CloseWebSocketUseCase,
    SubscribeToIncomingActionsUseCase,
    InitNotificationsServicesUseCase,
  ],
)
void main() {
  late SetupWebSocketChannelUseCase setupWebSocketChannelUseCase;
  late CloseWebSocketUseCase closeWebSocketUseCase;
  late SubscribeToIncomingActionsUseCase subscribeToIncomingActionsUseCase;
  late InitNotificationsServicesUseCase initNotificationsServicesUseCase;
  late MainPageCubit cubit;

  setUp(() {
    setupWebSocketChannelUseCase = MockSetupWebSocketChannelUseCase();
    closeWebSocketUseCase = MockCloseWebSocketUseCase();
    subscribeToIncomingActionsUseCase = MockSubscribeToIncomingActionsUseCase();
    initNotificationsServicesUseCase = MockInitNotificationsServicesUseCase();

    cubit = MainPageCubit(
      setupWebSocketChannelUseCase,
      subscribeToIncomingActionsUseCase,
      closeWebSocketUseCase,
      initNotificationsServicesUseCase,
    );
  });

  group('initialize', () {
    final incomingAction = IncomingAction('link');
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
