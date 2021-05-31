
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/auth/api/auth_api_data_source.dart';
import 'package:logpass_me/data/auth/api/initialize/initialize_login_dto.dart';
import 'package:logpass_me/data/auth/api/verify/tokens_result_dto.dart';
import 'package:logpass_me/domain/auth/auth_repository.dart';
import 'package:logpass_me/domain/auth/sign_up/sign_up_verification.dart';
import 'package:logpass_me/domain/auth/verification_method.dart';

@Singleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthApiDataSource _authApiDataSource;
  final UserTokensDTOMapper _userTokensDTOMapper;
  final VerificationMethodMapper _verificationMethodMapper;

  AuthRepositoryImpl(
    this._authApiDataSource,
    this._userTokensDTOMapper,
    this._verificationMethodMapper,
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
      _verificationMethodMapper.to(response.data.verificationMethod),
      response.data.verificationUrl,
      response.data.verificationData?.toSign,
    );
  }
}
