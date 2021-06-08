import 'package:bloc_test/bloc_test.dart' hide when, verify;
import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/app_security/app_security_type.dart';
import 'package:logpass_me/domain/app_security/use_case/authorize_with_biometrics_use_case.dart';
import 'package:logpass_me/domain/app_security/use_case/get_app_security_type_use_case.dart';
import 'package:logpass_me/domain/app_security/use_case/validate_pin_code_use_case.dart';
import 'package:logpass_me/presentation/page/secured_login/secured_login_page_cubit.dart';
import 'package:logpass_me/presentation/page/secured_login/secured_login_page_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'secured_login_page_cubit_test.mocks.dart';

@GenerateMocks(
  [
    GetAppSecurityTypeUseCase,
    ValidatePinCodeUseCase,
    AuthorizeWithBiometricsUseCase,
  ],
)
void main() {
  late GetAppSecurityTypeUseCase getAppSecurityTypeUseCase;
  late ValidatePinCodeUseCase validatePinCodeUseCase;
  late AuthorizeWithBiometricsUseCase authorizeWithBiometricsUseCase;
  late SecuredLoginPageCubit cubit;

  setUp(() {
    getAppSecurityTypeUseCase = MockGetAppSecurityTypeUseCase();
    validatePinCodeUseCase = MockValidatePinCodeUseCase();
    authorizeWithBiometricsUseCase = MockAuthorizeWithBiometricsUseCase();
    cubit = SecuredLoginPageCubit(
      getAppSecurityTypeUseCase,
      validatePinCodeUseCase,
      authorizeWithBiometricsUseCase,
    );
  });

  group('initialize', () {
    blocTest<SecuredLoginPageCubit, SecuredLoginPageState>(
      'emits correct state when security type is set to ${AppSecurityType.code}',
      build: () {
        when(getAppSecurityTypeUseCase()).thenAnswer((invocation) async => AppSecurityType.code);
        return cubit;
      },
      act: (cubit) => cubit.initialize(),
      expect: () => [
        SecuredLoginPageState.idle(AppSecurityType.code, false),
      ],
    );

    blocTest<SecuredLoginPageCubit, SecuredLoginPageState>(
      'when security type is ${AppSecurityType.biometric} start biometric auth',
      build: () {
        when(getAppSecurityTypeUseCase()).thenAnswer((invocation) async => AppSecurityType.biometric);
        when(authorizeWithBiometricsUseCase()).thenAnswer((realInvocation) async => true);
        return cubit;
      },
      act: (cubit) => cubit.initialize(),
      expect: () => [
        SecuredLoginPageState.idle(AppSecurityType.biometric, false),
        SecuredLoginPageState.validated(),
      ],
      verify: (cubit) {
        verify(authorizeWithBiometricsUseCase());
      },
    );
  });

  group('useBiometrics', () {
    setUp(() async {
      when(getAppSecurityTypeUseCase()).thenAnswer((invocation) async => AppSecurityType.biometric);
      await cubit.initialize();
    });

    blocTest<SecuredLoginPageCubit, SecuredLoginPageState>(
      'emit validated state on success',
      build: () {
        when(authorizeWithBiometricsUseCase()).thenAnswer((realInvocation) async => true);
        return cubit;
      },
      act: (cubit) => cubit.useBiometrics(),
      expect: () => [
        SecuredLoginPageState.validated(),
      ],
    );

    blocTest<SecuredLoginPageCubit, SecuredLoginPageState>(
      'do not emit anything when not authorized',
      build: () {
        when(authorizeWithBiometricsUseCase()).thenAnswer((realInvocation) async => false);
        return cubit;
      },
      act: (cubit) => cubit.useBiometrics(),
      expect: () => [],
    );

    blocTest<SecuredLoginPageCubit, SecuredLoginPageState>(
      'do not emit anything on exception',
      build: () {
        when(authorizeWithBiometricsUseCase()).thenAnswer((realInvocation) => throw Error());
        return cubit;
      },
      act: (cubit) => cubit.useBiometrics(),
      expect: () => [],
    );
  });

  group('updatePinCode', () {
    setUp(() async {
      when(getAppSecurityTypeUseCase()).thenAnswer((invocation) async => AppSecurityType.biometric);
      await cubit.initialize();
    });

    blocTest<SecuredLoginPageCubit, SecuredLoginPageState>(
      'emits nothing when pin code is not long enough',
      build: () => cubit,
      act: (cubit) => cubit.updatePinCode(''),
      expect: () => [],
    );

    blocTest<SecuredLoginPageCubit, SecuredLoginPageState>(
      'emits idle state when pin code is not long enough and last state is with error',
      build: () => cubit,
      act: (cubit) => cubit.updatePinCode(''),
      expect: () => [
        SecuredLoginPageState.idle(AppSecurityType.biometric, false),
      ],
      seed: () => SecuredLoginPageState.idle(AppSecurityType.biometric, true),
    );

    blocTest<SecuredLoginPageCubit, SecuredLoginPageState>(
      'emits validated state when pin code is valid',
      build: () => cubit,
      act: (cubit) {
        when(validatePinCodeUseCase('1234')).thenAnswer((realInvocation) async => true);
        return cubit.updatePinCode('1234');
      },
      expect: () => [
        SecuredLoginPageState.processing(),
        SecuredLoginPageState.validated(),
      ],
    );

    blocTest<SecuredLoginPageCubit, SecuredLoginPageState>(
      'emits [wrongPin, idle] states with error when pin code is invalid',
      build: () => cubit,
      act: (cubit) {
        when(validatePinCodeUseCase('1234')).thenAnswer((realInvocation) async => false);
        return cubit.updatePinCode('1234');
      },
      expect: () => [
        SecuredLoginPageState.processing(),
        SecuredLoginPageState.wrongPin(),
        SecuredLoginPageState.idle(AppSecurityType.biometric, true),
      ],
    );
  });
}
