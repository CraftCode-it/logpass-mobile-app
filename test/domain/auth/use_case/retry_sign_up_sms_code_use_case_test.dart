import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/auth/auth_repository.dart';
import 'package:logpass_me/domain/auth/sign_up/sign_up_verification.dart';
import 'package:logpass_me/domain/auth/verification_method.dart';
import 'package:mockito/annotations.dart';
import 'package:logpass_me/domain/auth/use_case/retry_sign_up_sms_code_use_case.dart';
import 'package:mockito/mockito.dart';

import 'retry_sign_up_sms_code_use_case_test.mocks.dart';

@GenerateMocks(
  [
    AuthRepository,
  ],
)
void main() {
  late AuthRepository authRepository;
  late RetrySignUpSmsCodeUseCase retrySignUpSmsCodeUseCase;

  setUp(() {
    authRepository = MockAuthRepository();
    retrySignUpSmsCodeUseCase = RetrySignUpSmsCodeUseCase(authRepository);
  });

  test('it calls with success and return verification', () async {
    const id = 'id';

    final expected = SignUpVerification('id', VerificationMethod.otpCode, 'https://some.url/verify', null);

    when(authRepository.retrySignUp(id)).thenAnswer((realInvocation) async => expected);

    final result = await retrySignUpSmsCodeUseCase(id);

    expect(result, expected);
    verify(authRepository.retrySignUp(id));
  });

  test('it throws error on failure', () async {
    const id = 'id';

    final expected = Error();

    when(authRepository.retrySignUp(id)).thenAnswer((realInvocation) => throw expected);

    expect(retrySignUpSmsCodeUseCase(id), throwsA(expected));
  });
}