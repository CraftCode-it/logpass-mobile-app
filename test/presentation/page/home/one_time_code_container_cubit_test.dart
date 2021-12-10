import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/internet_connection/use_case/dispose_internet_connection_use_case.dart';
import 'package:logpass_me/domain/internet_connection/use_case/get_internet_connection_use_case.dart';
import 'package:logpass_me/domain/internet_connection/use_case/listen_internet_connection_use_case.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/one_time_code/one_time_code.dart';
import 'package:logpass_me/domain/one_time_code/use_case/load_one_time_code_use_case.dart';
import 'package:logpass_me/domain/one_time_code/use_case/subscribe_to_one_time_code_use_case.dart';
import 'package:logpass_me/presentation/widget/one_time_code_container/one_time_code_container_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:bloc_test/bloc_test.dart' hide when, verify;
import 'package:mockito/mockito.dart';

import 'one_time_code_container_cubit_test.mocks.dart';

@GenerateMocks(
  [
    LoadOneTimeCodeUseCase,
    SubscribeToOnetimeCodeUseCase,
    GetInternetConnectionUseCase,
    ListenInternetConnectionUseCase,
    DisposeInternetConnectionUseCase

  ],
)
void main() {
  late LoadOneTimeCodeUseCase loadOneTimeCodeUseCase;
  late SubscribeToOnetimeCodeUseCase subscribeToOnetimeCodeUseCase;
  late GetInternetConnectionUseCase getInternetConnectionUseCase;
  late ListenInternetConnectionUseCase listenInternetConnectionUseCase;
  late DisposeInternetConnectionUseCase disposeInternetConnectionUseCase;
  late OneTimeCodeContainerCubit cubit;

  setUp(() {
    loadOneTimeCodeUseCase = MockLoadOneTimeCodeUseCase();
    subscribeToOnetimeCodeUseCase = MockSubscribeToOnetimeCodeUseCase();
    getInternetConnectionUseCase = MockGetInternetConnectionUseCase();
    listenInternetConnectionUseCase = MockListenInternetConnectionUseCase();
    disposeInternetConnectionUseCase = MockDisposeInternetConnectionUseCase();

    cubit = OneTimeCodeContainerCubit(
      loadOneTimeCodeUseCase,
      subscribeToOnetimeCodeUseCase,
      getInternetConnectionUseCase,
      listenInternetConnectionUseCase,
      disposeInternetConnectionUseCase,
    );
  });

  final noConnectionError = GeneralConnectionError.noConnection();
  final now = DateTime.now();
  final oneTimeCode = OneTimeCode(
    'code',
    const Duration(minutes: 10),
    now,
    now.add(const Duration(minutes: 10)),
  );

  group('initialize', () {
    const internetConnected = true;

    setUp(() {
      when(getInternetConnectionUseCase()).thenAnswer((realInvocation) async => internetConnected);
    });

    blocTest<OneTimeCodeContainerCubit, OneTimeCodeContainerState>(
      'emits idle state with code after init\'s load',
      build: () {
        when(loadOneTimeCodeUseCase()).thenAnswer((realInvocation) async => {});
        when(subscribeToOnetimeCodeUseCase()).thenAnswer((realInvocation) => Stream.value(oneTimeCode));

        return cubit;
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        const OneTimeCodeContainerState.loadInProgress(),
        OneTimeCodeContainerState.idle(oneTimeCode),
      ],
    );

    blocTest<OneTimeCodeContainerCubit, OneTimeCodeContainerState>(
      'emits error state on failure ',
      build: () {
        const error = Error();
        when(loadOneTimeCodeUseCase()).thenAnswer((realInvocation) async => throw error);
        when(subscribeToOnetimeCodeUseCase()).thenAnswer((realInvocation) => Stream.value(null));

        return cubit;
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        const OneTimeCodeContainerState.loadInProgress(),
        const OneTimeCodeContainerState.error(),
      ],
    );

    blocTest<OneTimeCodeContainerCubit, OneTimeCodeContainerState>(
      'emits ConnectionError state during initializing when internet is connected',
      build: () {
        when(loadOneTimeCodeUseCase()).thenAnswer((realInvocation) async => throw noConnectionError);
        when(subscribeToOnetimeCodeUseCase()).thenAnswer((realInvocation) => Stream.value(null));

        return cubit;
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        const OneTimeCodeContainerState.loadInProgress(),
        OneTimeCodeContainerState.connectionError(noConnectionError),
        const OneTimeCodeContainerState.internetConnection(true),
        const OneTimeCodeContainerState.error(),
      ],
    );

    blocTest<OneTimeCodeContainerCubit, OneTimeCodeContainerState>(
      'emits ConnectionError state during initializing when internet is disconnected',
      build: () {
        when(getInternetConnectionUseCase()).thenAnswer((realInvocation) async => false);
        when(loadOneTimeCodeUseCase()).thenAnswer((realInvocation) async => throw noConnectionError);
        when(subscribeToOnetimeCodeUseCase()).thenAnswer((realInvocation) => Stream.value(null));

        return cubit;
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        const OneTimeCodeContainerState.loadInProgress(),
        OneTimeCodeContainerState.connectionError(noConnectionError),
        const OneTimeCodeContainerState.internetConnection(false),
        const OneTimeCodeContainerState.error(),
      ],
    );

    blocTest<OneTimeCodeContainerCubit, OneTimeCodeContainerState>(
      'verify code refresh after its expiration time',
      build: () {
        when(loadOneTimeCodeUseCase()).thenAnswer((realInvocation) async => {});
        when(subscribeToOnetimeCodeUseCase()).thenAnswer((realInvocation) => Stream.value(oneTimeCode));

        return cubit;
      },
      act: (cubit) => cubit.init(),
      expect: () => [
        const OneTimeCodeContainerState.loadInProgress(),
        OneTimeCodeContainerState.idle(oneTimeCode)
      ],
      verify: (cubit) {
        verify(cubit.refreshOneTimeCode());
      },
    );
  });
}
