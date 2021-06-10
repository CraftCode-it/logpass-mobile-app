import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/data/auth/api/auth_api_data_source.dart';
import 'package:logpass_me/data/auth/api/initialize/initialize_login_result_dto.dart';
import 'package:logpass_me/data/auth/api/verify/tokens_result_dto.dart';
import 'package:logpass_me/data/auth/auth_repository_impl.dart';
import 'package:logpass_me/data/networking/error/logpass_dio_error_wrapper.dart';
import 'package:logpass_me/domain/auth/error/login_verification_error.dart';
import 'package:logpass_me/domain/auth/sign_up/sign_up_verification.dart';
import 'package:logpass_me/domain/auth/token/access_token.dart';
import 'package:logpass_me/domain/auth/token/user_tokens.dart';
import 'package:logpass_me/domain/auth/verification_method.dart';
import 'package:logpass_me/domain/networking/error/logpass_api_error.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_impl_test.mocks.dart';

class FakeTokensResultDTO extends Fake implements TokensResultDTO {}

class FakeLogpassDioErrorWrapper extends Fake implements LogpassDioErrorWrapper {
  final LogpassApiError mockedError;

  FakeLogpassDioErrorWrapper(this.mockedError);

  @override
  LogpassApiError get logpassApiError => mockedError;
}

@GenerateMocks(
  [
    AuthApiDataSource,
    UserTokensDTOMapper,
    VerificationMethodMapper,
    LoginVerificationErrorMapper,
  ],
)
void main() {
  late MockAuthApiDataSource authApiDataSource;
  late MockUserTokensDTOMapper userTokensDTOMapper;
  late MockVerificationMethodMapper verificationMethodMapper;
  late LoginVerificationErrorMapper loginVerificationErrorMapper;
  late AuthRepositoryImpl authRepositoryImpl;

  setUp(() {
    authApiDataSource = MockAuthApiDataSource();
    userTokensDTOMapper = MockUserTokensDTOMapper();
    verificationMethodMapper = MockVerificationMethodMapper();
    loginVerificationErrorMapper = MockLoginVerificationErrorMapper();
    authRepositoryImpl = AuthRepositoryImpl(
      authApiDataSource,
      userTokensDTOMapper,
      verificationMethodMapper,
      loginVerificationErrorMapper,
    );
  });

  group('signUp', () {
    test('returns verification result on success', () async {
      const phoneNumber = '+48000000000';
      const verifyKey = 'abcd==';
      const publicKey = 'dfeg==';

      final apiResult = InitializeLoginResultDTO(
        InitializeLoginLinksDTO(
          'https://some.url/verify',
        ),
        InitializeLoginResultDataDTO(
          'otp_code',
          null,
        ),
      );

      final expected = SignUpVerification(phoneNumber, VerificationMethod.otpCode, 'https://some.url/verify', null);

      when(authApiDataSource.initializeLoginProcess(any)).thenAnswer((realInvocation) async => apiResult);
      when(verificationMethodMapper.to('otp_code')).thenAnswer((realInvocation) => VerificationMethod.otpCode);

      final actual = await authRepositoryImpl.signUp(phoneNumber, verifyKey, publicKey);

      expect(actual, expected);
    });

    test('throws error when api call fails', () async {
      const phoneNumber = '+48000000000';
      const verifyKey = 'abcd==';
      const publicKey = 'dfeg==';

      final expected = Error();

      when(authApiDataSource.initializeLoginProcess(any)).thenAnswer((realInvocation) => throw expected);

      expect(authRepositoryImpl.signUp(phoneNumber, verifyKey, publicKey), throwsA(expected));
    });
  });

  group('verifyOTPSignUp', () {
    test('returns tokens on success', () async {
      const url = 'https://api/verify';
      const code = '123456';

      final response = FakeTokensResultDTO();

      final expected = UserTokens(
        accessToken: AccessToken(
          token: 'access',
          type: 'otp',
        ),
        refreshToken: 'refresh',
        sub: 'sub',
      );

      when(authApiDataSource.verifyLoginProcess(url, any)).thenAnswer((realInvocation) async => response);
      when(userTokensDTOMapper(response)).thenAnswer((realInvocation) => expected);

      final actual = await authRepositoryImpl.verifyOTPSignUp(url, code);

      expect(actual, expected);
    });

    test('throws error on unhandled error', () async {
      const url = 'https://api/verify';
      const code = '123456';

      final expected = Error();

      when(authApiDataSource.verifyLoginProcess(url, any)).thenAnswer((realInvocation) => throw expected);

      expect(authRepositoryImpl.verifyOTPSignUp(url, code), throwsA(expected));
    });

    test('throws custom error when LogpassApiError thrown', () async {
      const url = 'https://api/verify';
      const code = '123456';

      final apiError = FakeLogpassDioErrorWrapper(
        LogpassApiError.verificationFailed(
          'Message',
          [],
        ),
      );
      final expected = LoginVerificationError.invalidCode('Code invalid');

      when(authApiDataSource.verifyLoginProcess(url, any)).thenAnswer((realInvocation) => throw apiError);
      when(loginVerificationErrorMapper(apiError.logpassApiError)).thenAnswer((realInvocation) => expected);

      expect(authRepositoryImpl.verifyOTPSignUp(url, code), throwsA(expected));
    });
  });
}
