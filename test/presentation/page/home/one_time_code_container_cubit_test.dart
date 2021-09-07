import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
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
  ],
)
void main() {
  late LoadOneTimeCodeUseCase loadOneTimeCodeUseCase;
  late SubscribeToOnetimeCodeUseCase subscribeToOnetimeCodeUseCase;
  late OneTimeCodeContainerCubit cubit;

  setUp(() {
    loadOneTimeCodeUseCase = MockLoadOneTimeCodeUseCase();
    subscribeToOnetimeCodeUseCase = MockSubscribeToOnetimeCodeUseCase();
    cubit = OneTimeCodeContainerCubit(loadOneTimeCodeUseCase, subscribeToOnetimeCodeUseCase);
  });

  group('initialize', () {
    final now = DateTime.now();
    final oneTimeCode = OneTimeCode(
      'code',
      const Duration(minutes: 10),
      now,
      now.add(const Duration(minutes: 10)),
    );

    blocTest<OneTimeCodeContainerCubit, OneTimeCodeContainerState>(
      'emits idle state with code after init\'s load',
      build: () {
        when(loadOneTimeCodeUseCase()).thenAnswer((realInvocation) async => {});
        when(subscribeToOnetimeCodeUseCase()).thenAnswer((realInvocation) => Stream.value(oneTimeCode));

        return cubit;
      },
      act: (cubit) async {
        await withClock(Clock.fixed(now), cubit.init);
      },
      wait: const Duration(seconds: 2),
      expect: () => [
        const OneTimeCodeContainerState.loadInProgress(),
        OneTimeCodeContainerState.idle(oneTimeCode, 1.0),
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
      'verify code refresh after its expiration time',
      build: () {
        final expiredCode = OneTimeCode(
          'code',
          const Duration(seconds: 1),
          now,
          now.subtract(const Duration(seconds: 1)),
        );
        when(loadOneTimeCodeUseCase()).thenAnswer((realInvocation) async => {});
        when(subscribeToOnetimeCodeUseCase()).thenAnswer((realInvocation) => Stream.value(expiredCode));

        return cubit;
      },
      act: (cubit) async {
        await withClock(Clock.fixed(now), cubit.init);
      },
      wait: const Duration(seconds: 1),
      expect: () => [
        const OneTimeCodeContainerState.loadInProgress(),
      ],
      verify: (cubit) {
        verify(cubit.refreshOneTimeCode());
      },
    );
  });
}
