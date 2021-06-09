import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/auth/api/auth_api_data_source.dart';
import 'package:logpass_me/data/auth/api/initialize/initialize_login_dto.dart';
import 'package:logpass_me/data/auth/api/verify/tokens_result_dto.dart';
import 'package:logpass_me/data/auth/api/verify/verify_login_dto.dart';
import 'package:logpass_me/data/networking/error/dio_error_wrapper.dart';
import 'package:logpass_me/domain/auth/auth_repository.dart';
import 'package:logpass_me/domain/auth/error/login_verification_error.dart';
import 'package:logpass_me/domain/auth/sign_up/sign_up_verification.dart';
import 'package:logpass_me/domain/auth/token/user_tokens.dart';
import 'package:logpass_me/domain/auth/verification_method.dart';

@Singleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthApiDataSource _authApiDataSource;
  final UserTokensDTOMapper _userTokensDTOMapper;
  final VerificationMethodMapper _verificationMethodMapper;
  final LoginVerificationErrorMapper _loginVerificationErrorMapper;

  AuthRepositoryImpl(
    this._authApiDataSource,
    this._userTokensDTOMapper,
    this._verificationMethodMapper,
    this._loginVerificationErrorMapper,
  );

  @override
  Future<SignUpVerification> signUp(String phoneNumber, String verifyKey, String publicKey) async {
    final requestBody = InitializeLoginDTO(
      credential: phoneNumber,
      rawVerifyKey: verifyKey,
      rawPublicKey: publicKey,
    );

    final response = await _authApiDataSource.initializeLoginProcess(requestBody);

    return SignUpVerification(
      phoneNumber,
      _verificationMethodMapper.to(response.data.verificationMethod),
      response.data.verificationUrl,
      response.data.verificationData?.toSign,
    );
  }

  @override
  Future<UserTokens> verifyOTPSignUp(String url, String otpCode) async {
    final request = VerifyLoginDTO(secret: otpCode);

    try {
      final response = await _authApiDataSource.verifyLoginProcess(url, request);
      return _userTokensDTOMapper(response);
    } on LogpassDioErrorWrapper catch (apiError) {
      throw _loginVerificationErrorMapper(apiError.logpassApiError);
    }
  }
}
