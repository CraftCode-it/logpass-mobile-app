import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/subscribe_to_incoming_actions_use_case.dart';
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
  ],
)
void main() {
  late SetupWebSocketChannelUseCase setupWebSocketChannelUseCase;
  late CloseWebSocketUseCase closeWebSocketUseCase;
  late SubscribeToIncomingActionsUseCase subscribeToIncomingActionsUseCase;
  late MainPageCubit cubit;

  setUp(() {
    setupWebSocketChannelUseCase = MockSetupWebSocketChannelUseCase();
    closeWebSocketUseCase = MockCloseWebSocketUseCase();
    subscribeToIncomingActionsUseCase = MockSubscribeToIncomingActionsUseCase();
    cubit = MainPageCubit(setupWebSocketChannelUseCase, subscribeToIncomingActionsUseCase, closeWebSocketUseCase);
  });

  group('initialize', () {
    final incomingAction = IncomingAction('link');
    const failureMessage = 'Error message';

    blocTest<MainPageCubit, MainPageState>(
      'emits idle on successful subscriptions setup',
      build: () {
        when(setupWebSocketChannelUseCase()).thenAnswer((invocation) async => {});
        when(subscribeToIncomingActionsUseCase()).thenAnswer((invocation) => Stream.value(incomingAction));

        return cubit;
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        const MainPageState.idle(),
      ],
    );

    blocTest<MainPageCubit, MainPageState>(
      'emits [Error, Idle] on WS channel setup failure',
      build: () {
        final expect = Exception();
        when(setupWebSocketChannelUseCase()).thenAnswer((invocation) async => throw expect);
        when(subscribeToIncomingActionsUseCase()).thenAnswer((invocation) => Stream.value(incomingAction));

        return cubit;
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        const MainPageState.error(failureMessage),
        const MainPageState.idle(),
      ],
    );
  });
}
