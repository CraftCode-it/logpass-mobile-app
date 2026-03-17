import 'package:bloc_test/bloc_test.dart' hide when;
import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/app_security/use_case/authorize_with_biometrics_use_case.dart';
import 'package:logpass_me/domain/app_security/use_case/is_biometric_available_use_case.dart';
import 'package:logpass_me/domain/app_security/use_case/set_app_security_type_use_case.dart';
import 'package:logpass_me/presentation/page/get_safer/get_safer_cubit.dart';
import 'package:logpass_me/presentation/page/get_safer/get_safer_page_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_safer_cubit_test.mocks.dart';

@GenerateMocks(
  [
    IsBiometricAvailableUseCase,
    SetAppSecurityTypeUseCase,
    AuthorizeWithBiometricsUseCase,
  ],
)
void main() {
  late IsBiometricAvailableUseCase isBiometricAvailableUseCase;
  late SetAppSecurityTypeUseCase setAppSecurityTypeUseCase;
  late AuthorizeWithBiometricsUseCase authorizeWithBiometricsUseCase;
  late GetSaferCubit cubit;

  setUp(() {
    isBiometricAvailableUseCase = MockIsBiometricAvailableUseCase();
    setAppSecurityTypeUseCase = MockSetAppSecurityTypeUseCase();
    authorizeWithBiometricsUseCase = MockAuthorizeWithBiometricsUseCase();
    cubit = GetSaferCubit(
      isBiometricAvailableUseCase,
      setAppSecurityTypeUseCase,
      authorizeWithBiometricsUseCase,
    );
  });

  group('initialize', () {
    blocTest<GetSaferCubit, GetSaferPageState>(
      'when device supports biometrics',
      build: () {
        when(isBiometricAvailableUseCase()).thenAnswer((invocation) async => true);
        return cubit;
      },
      act: (cubit) => cubit.initialize(),
      expect: () => [GetSaferPageState.idle(true)],
    );

    blocTest<GetSaferCubit, GetSaferPageState>(
      'when device does not support biometrics',
      build: () {
        when(isBiometricAvailableUseCase()).thenAnswer((invocation) async => false);
        return cubit;
      },
      act: (cubit) => cubit.initialize(),
      expect: () => [GetSaferPageState.idle(false)],
    );
  });

  group('invokeBiometricsSetup', () {
    setUp(() async {
      when(isBiometricAvailableUseCase()).thenAnswer((invocation) async => true);
      await cubit.initialize();
    });

    blocTest<GetSaferCubit, GetSaferPageState>(
      'when authorization is not successful',
      build: () {
        when(authorizeWithBiometricsUseCase()).thenAnswer((realInvocation) async => false);
        return cubit;
      },
      act: (cubit) => cubit.invokeBiometricsSetup(),
      expect: () => [
        GetSaferPageState.loading(),
        GetSaferPageState.idle(true),
      ],
    );

    blocTest<GetSaferCubit, GetSaferPageState>(
      'when authorization is successful',
      build: () {
        when(authorizeWithBiometricsUseCase()).thenAnswer((realInvocation) async => true);
        return cubit;
      },
      act: (cubit) => cubit.invokeBiometricsSetup(),
      expect: () => [
        GetSaferPageState.loading(),
        GetSaferPageState.setCodeForBiometrics(),
        GetSaferPageState.idle(true),
      ],
    );

    blocTest<GetSaferCubit, GetSaferPageState>(
      'when authorization throws error',
      build: () {
        when(authorizeWithBiometricsUseCase()).thenAnswer((realInvocation) => throw Error());
        return cubit;
      },
      act: (cubit) => cubit.invokeBiometricsSetup(),
      expect: () => [
        GetSaferPageState.loading(),
        GetSaferPageState.idle(true),
      ],
    );
  });
}
