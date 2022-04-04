import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/app/use_case/is_first_run_app_use_case.dart';
import 'package:logpass_me/domain/auth/use_case/is_logged_in_use_case.dart';
import 'package:logpass_me/domain/auth/use_case/logout_without_listenable_callback_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/setup_initial_action_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/switch_pre_login_action_handler_use_case.dart';
import 'package:logpass_me/presentation/page/entry/entry_page_cubit.dart';
import 'package:logpass_me/presentation/page/entry/entry_page_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'entry_page_cubit_test.mocks.dart';

@GenerateMocks(
  [
    LogoutWithoutListenableCallbackUseCase,
    IsLoggedInUseCase,
    IsFirstRunAppUseCase,
    SetupInitialActionUseCase,
    SwitchPreLoginActionHandlerUseCase,
  ],
)
void main() {
  late LogoutWithoutListenableCallbackUseCase logoutWithoutListenableCallbackUseCase;
  late IsLoggedInUseCase isLoggedInUseCase;
  late IsFirstRunAppUseCase isFirstRunAppUseCase;
  late SetupInitialActionUseCase setupInitialActionUseCase;
  late SwitchPreLoginActionHandlerUseCase switchPreLoginActionHandlerUseCase;

  late EntryPageCubit cubit;

  setUp(() {
    logoutWithoutListenableCallbackUseCase = MockLogoutWithoutListenableCallbackUseCase();
    isLoggedInUseCase = MockIsLoggedInUseCase();
    isFirstRunAppUseCase = MockIsFirstRunAppUseCase();
    setupInitialActionUseCase = MockSetupInitialActionUseCase();
    switchPreLoginActionHandlerUseCase = MockSwitchPreLoginActionHandlerUseCase();

    cubit = EntryPageCubit(
      logoutWithoutListenableCallbackUseCase,
      isLoggedInUseCase,
      isFirstRunAppUseCase,
      setupInitialActionUseCase,
      switchPreLoginActionHandlerUseCase
    );
  });

  group('initialize', () {

    setUp(() {
      when(setupInitialActionUseCase()).thenAnswer((_) async => Future.value(null));
    });

    blocTest<EntryPageCubit, EntryPageState>(
      'first app run emit onboarding',
      build: () {
        when(isFirstRunAppUseCase()).thenAnswer((_) async => true);
        when(logoutWithoutListenableCallbackUseCase()).thenAnswer((_) async => Future.value(null));
        when(switchPreLoginActionHandlerUseCase(true)).thenAnswer((_) async => Future.value(null));
        return cubit;
      },
      act: (cubit) => cubit.initialize(),
      expect: () =>
      [
        EntryPageState.onboarding(),
      ],
    );

    blocTest<EntryPageCubit, EntryPageState>(
      'not first app run and user no logged in emit onboarding',
      build: () {
        when(isFirstRunAppUseCase()).thenAnswer((_) async => false);
        when(isLoggedInUseCase()).thenAnswer((_) async => false);
        when(switchPreLoginActionHandlerUseCase(true)).thenAnswer((_) async => Future.value(null));
        return cubit;
      },
      act: (cubit) => cubit.initialize(),
      expect: () =>
      [
        EntryPageState.onboarding(),
      ],
    );

    blocTest<EntryPageCubit, EntryPageState>(
      'not first app run and user is logged in emit home',
      build: () {
        when(isFirstRunAppUseCase()).thenAnswer((_) async => false);
        when(isLoggedInUseCase()).thenAnswer((_) async => true);
        return cubit;
      },
      act: (cubit) => cubit.initialize(),
      expect: () =>
      [
        EntryPageState.home(),
      ],
    );
  });
}