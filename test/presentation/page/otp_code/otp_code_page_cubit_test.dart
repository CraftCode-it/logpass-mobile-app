import 'package:bloc_test/bloc_test.dart' hide when;
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/auth/sign_up/sign_up_verification.dart';
import 'package:logpass_me/domain/auth/use_case/verify_otp_sign_up_use_case.dart';
import 'package:logpass_me/domain/auth/verification_method.dart';
import 'package:logpass_me/presentation/page/otp_code/otp_code_page_cubit.dart';
import 'package:logpass_me/presentation/page/otp_code/otp_code_page_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'otp_code_page_cubit_test.mocks.dart';

@GenerateMocks(
  [
    VerifyOTPSignUpUseCase,
  ],
)
void main() {
  late VerifyOTPSignUpUseCase verifyOTPSignUpUseCase;
  late OTPCodePageCubit cubit;

  setUp(() {
    verifyOTPSignUpUseCase = MockVerifyOTPSignUpUseCase();
    cubit = OTPCodePageCubit(verifyOTPSignUpUseCase);
  });

  final nowDateTime = DateTime(2021);
  final basicResendTimestamp = nowDateTime.add(OTPCodePageCubit.resendDelayDuration);
  final verification = SignUpVerification(VerificationMethod.otpCode, 'https://url', null);

  group('initialize', () {
    blocTest<OTPCodePageCubit, OTPCodePageState>(
      'emits idle state after initialization',
      build: () => cubit,
      act: (cubit) => withClock(Clock.fixed(nowDateTime), () => cubit.initialize(verification)),
      expect: () => [OTPCodePageState.idle('', false, basicResendTimestamp)],
    );
  });

  group('updateCode', () {
    setUp(() {
      withClock(Clock.fixed(nowDateTime), () => cubit.initialize(verification));
    });

    blocTest<OTPCodePageCubit, OTPCodePageState>(
      'emits state with correct code',
      build: () => cubit,
      act: (cubit) => cubit..updateCode('123')..updateCode('1234')..updateCode('123'),
      expect: () => [
        OTPCodePageState.idle('123', false, basicResendTimestamp),
        OTPCodePageState.idle('1234', false, basicResendTimestamp),
        OTPCodePageState.idle('123', false, basicResendTimestamp),
      ],
    );

    blocTest<OTPCodePageCubit, OTPCodePageState>(
      'emits state with correct validation',
      build: () => cubit,
      act: (cubit) => cubit..updateCode('123456')..updateCode('12345'),
      expect: () => [
        OTPCodePageState.idle('123456', true, basicResendTimestamp),
        OTPCodePageState.idle('12345', false, basicResendTimestamp),
      ],
    );
  });

  group('resendCode', () {
    setUp(() {
      withClock(Clock.fixed(nowDateTime), () => cubit.initialize(verification));
    });

    blocTest<OTPCodePageCubit, OTPCodePageState>(
      'emits state with updated resendAvailabilityTimestamp',
      build: () => cubit,
      act: (cubit) {
        cubit.updateCode('123');
        withClock(Clock.fixed(basicResendTimestamp), () => cubit.resendCode());
      },
      expect: () => [
        OTPCodePageState.idle('123', false, basicResendTimestamp),
        OTPCodePageState.idle('123', false, basicResendTimestamp.add(OTPCodePageCubit.resendDelayDuration)),
      ],
    );
  });

  group('verify', () {
    setUp(() {
      withClock(Clock.fixed(nowDateTime), () => cubit.initialize(verification));
    });

    blocTest<OTPCodePageCubit, OTPCodePageState>(
      'emits states for success verification flow',
      build: () {
        when(verifyOTPSignUpUseCase(verification.verificationUrl, '123456')).thenAnswer((invocation) async {});
        return cubit;
      },
      act: (cubit) => cubit
        ..updateCode('123456')
        ..verify(),
      expect: () => [
        OTPCodePageState.idle('123456', true, basicResendTimestamp),
        OTPCodePageState.processing('123456'),
        OTPCodePageState.success(),
        OTPCodePageState.idle('123456', true, basicResendTimestamp),
      ],
    );
  });
}
