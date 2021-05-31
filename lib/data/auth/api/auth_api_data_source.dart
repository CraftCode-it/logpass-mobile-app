import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/auth/api/initialize/initialize_login_dto.dart';
import 'package:logpass_me/data/auth/api/initialize/initialize_login_result_dto.dart';
import 'package:logpass_me/data/auth/api/verify/tokens_result_dto.dart';
import 'package:logpass_me/data/auth/api/verify/verify_login_dto.dart';
import 'package:logpass_me/data/networking/log_pass_dio.dart';
import 'package:retrofit/http.dart';

part 'auth_api_data_source.g.dart';

@Singleton()
@RestApi()
abstract class AuthApiDataSource {
  @factoryMethod
  factory AuthApiDataSource(LogPassDio dio) = _AuthApiDataSource;

  @POST('/auth/users/regular/login/')
  Future<InitializeLoginResultDTO> initializeLoginProcess(@Body() InitializeLoginDTO body);

  @PUT('/auth/users/regular/login/{loginAttemptId}')
  Future<TokensResultDTO> verifyLoginProcess(
    @Path('loginAttemptId') String attemptId,
    @Body() VerifyLoginDTO body,
  );

  @DELETE('/auth/users/regular/login/{loginAttemptId}')
  Future<void> abortLoginProcess(@Path('loginAttemptId') String attemptId);

  @DELETE('/users/self/tokens/{tokenId}')
  Future<void> revokeAccessToken(@Path('tokenId') String tokenId);
}
