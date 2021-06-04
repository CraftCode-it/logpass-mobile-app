import 'package:bloc_test/bloc_test.dart' hide when, verify;
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/auth/sign_up/sign_up_verification.dart';
import 'package:logpass_me/domain/auth/use_case/sign_up_using_otp_code_use_case.dart';
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
    SignUpUsingOTPCodeUseCase,
  ],
)
void main() {
  late VerifyOTPSignUpUseCase verifyOTPSignUpUseCase;
  late SignUpUsingOTPCodeUseCase signUpUsingOTPCodeUseCase;
  late OTPCodePageCubit cubit;

  setUp(() {
    verifyOTPSignUpUseCase = MockVerifyOTPSignUpUseCase();
    signUpUsingOTPCodeUseCase = MockSignUpUsingOTPCodeUseCase();
    cubit = OTPCodePageCubit(verifyOTPSignUpUseCase, signUpUsingOTPCodeUseCase);
  });

  final nowDateTime = DateTime(2021);
  final basicResendTimestamp = nowDateTime.add(OTPCodePageCubit.resendDelayDuration);
  final verification = SignUpVerification('+49123123123', VerificationMethod.otpCode, 'https://url', null);

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
    final newVerification = SignUpVerification('+49123123123', VerificationMethod.otpCode, 'https://url/2', null);

    setUp(() {
      withClock(Clock.fixed(nowDateTime), () => cubit.initialize(verification));
    });

    blocTest<OTPCodePageCubit, OTPCodePageState>(
      'emits [Resending, Idle] states on success',
      build: () {
        when(signUpUsingOTPCodeUseCase(verification.phoneNumber)).thenAnswer((realInvocation) async => newVerification);

        return cubit;
      },
      act: (cubit) {
        cubit.updateCode('123');
        withClock(Clock.fixed(basicResendTimestamp), () => cubit.resendCode());
      },
      expect: () => [
        OTPCodePageState.idle('123', false, basicResendTimestamp),
        OTPCodePageState.resending('123'),
        OTPCodePageState.idle('123', false, basicResendTimestamp.add(OTPCodePageCubit.resendDelayDuration)),
      ],
    );

    blocTest<OTPCodePageCubit, OTPCodePageState>(
      'after resend verify is being called with new url',
      build: () {
        when(signUpUsingOTPCodeUseCase(verification.phoneNumber)).thenAnswer((realInvocation) async => newVerification);
        when(verifyOTPSignUpUseCase(verification.verificationUrl, '123456')).thenAnswer((invocation) async {});

        return cubit;
      },
      act: (cubit) async {
        await withClock(Clock.fixed(basicResendTimestamp), () => cubit.resendCode());
        cubit.updateCode('123456');
        await cubit.verify();
      },
      expect: () => [
        OTPCodePageState.resending(''),
        OTPCodePageState.idle('', false, basicResendTimestamp.add(OTPCodePageCubit.resendDelayDuration)),
        OTPCodePageState.idle('123456', true, basicResendTimestamp.add(OTPCodePageCubit.resendDelayDuration)),
        OTPCodePageState.verifying('123456'),
        OTPCodePageState.success(),
        OTPCodePageState.idle('123456', true, basicResendTimestamp.add(OTPCodePageCubit.resendDelayDuration)),
      ],
      verify: (cubit) {
        verify(verifyOTPSignUpUseCase(newVerification.verificationUrl, '123456'));
      },
    );

    blocTest<OTPCodePageCubit, OTPCodePageState>(
      'emits [Processing, Error, Idle] states on error',
      build: () {
        return cubit;
      },
      act: (cubit) {
        cubit.updateCode('123');
        withClock(Clock.fixed(basicResendTimestamp), () => cubit.resendCode());
      },
      expect: () => [
        OTPCodePageState.idle('123', false, basicResendTimestamp),
        OTPCodePageState.resending('123'),
        OTPCodePageState.error(),
        OTPCodePageState.idle('123', false, basicResendTimestamp.add(OTPCodePageCubit.resendDelayDuration)),
      ],
      verify: (cubit) {},
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
        OTPCodePageState.verifying('123456'),
        OTPCodePageState.success(),
        OTPCodePageState.idle('123456', true, basicResendTimestamp),
      ],
    );
  });
}
