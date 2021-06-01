import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/data/auth/api/auth_api_data_source.dart';
import 'package:logpass_me/data/auth/api/initialize/initialize_login_result_dto.dart';
import 'package:logpass_me/data/auth/api/verify/tokens_result_dto.dart';
import 'package:logpass_me/data/auth/auth_repository_impl.dart';
import 'package:logpass_me/domain/auth/sign_up/sign_up_verification.dart';
import 'package:logpass_me/domain/auth/verification_method.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks(
  [
    AuthApiDataSource,
    UserTokensDTOMapper,
    VerificationMethodMapper,
  ],
)
void main() {
  late MockAuthApiDataSource authApiDataSource;
  late MockUserTokensDTOMapper userTokensDTOMapper;
  late MockVerificationMethodMapper verificationMethodMapper;
  late AuthRepositoryImpl authRepositoryImpl;

  setUp(() {
    authApiDataSource = MockAuthApiDataSource();
    userTokensDTOMapper = MockUserTokensDTOMapper();
    verificationMethodMapper = MockVerificationMethodMapper();
    authRepositoryImpl = AuthRepositoryImpl(authApiDataSource, userTokensDTOMapper, verificationMethodMapper);
  });

  group('signUp', () {
    test('returns verification result on success', () async {
      const phoneNumber = '+48000000000';
      const verifyKey = 'abcd==';
      const publicKey = 'dfeg==';

      final apiResult = InitializeLoginResultDTO(
        InitializeLoginResultDataDTO(
          'https://some.url/verify',
          'otp_code',
          null,
        ),
      );

      final expected = SignUpVerification(VerificationMethod.otpCode, 'https://some.url/verify', null);

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
}
