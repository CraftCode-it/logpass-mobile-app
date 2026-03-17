import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/auth/auth_repository.dart';
import 'package:logpass_me/domain/auth/auth_store.dart';
import 'package:logpass_me/domain/auth/token/user_tokens.dart';
import 'package:logpass_me/domain/auth/use_case/verify_otp_sign_up_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'verify_otp_sign_up_use_case_test.mocks.dart';

class FakeUserTokens extends Fake implements UserTokens {}

@GenerateMocks(
  [
    AuthRepository,
    AuthStore,
  ],
)
void main() {
  late AuthRepository authRepository;
  late AuthStore authStore;
  late VerifyOTPSignUpUseCase verifyOTPSignUpUseCase;

  setUp(() {
    authRepository = MockAuthRepository();
    authStore = MockAuthStore();
    verifyOTPSignUpUseCase = VerifyOTPSignUpUseCase(authRepository, authStore);
  });

  test('it saves tokens to storage on success', () async {
    const url = 'https://api/verify';
    const code = '123456';

    final tokens = FakeUserTokens();

    when(authRepository.verifyOTPSignUp(url, code)).thenAnswer((realInvocation) async => tokens);
    when(authStore.saveUserTokens(tokens)).thenAnswer((realInvocation) async {});

    await verifyOTPSignUpUseCase(url, code);

    verify(authStore.saveUserTokens(tokens));
  });

  test('it throws error on failure', () async {
    const url = 'https://api/verify';
    const code = '123456';

    final tokens = FakeUserTokens();
    final expected = Error();

    when(authRepository.verifyOTPSignUp(url, code)).thenAnswer((realInvocation) => throw expected);

    expect(verifyOTPSignUpUseCase(url, code), throwsA(expected));
    verifyNever(authStore.saveUserTokens(tokens));
  });
}
