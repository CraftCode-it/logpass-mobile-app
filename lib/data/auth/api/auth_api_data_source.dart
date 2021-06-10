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
class AuthApiDataSource extends __AuthApiDataSource implements _AuthApiDataSource {
  AuthApiDataSource(LogPassDio dio) : super(dio);

  Future<TokensResultDTO> verifyLoginProcess(String url, VerifyLoginDTO body) async {
    final options = Options(method: HttpMethod.PUT, headers: <String, dynamic>{}, extra: <String, dynamic>{})
        .compose(_dio.options, url, data: body.toJson());

    final result = await _dio.fetch(options);

    return TokensResultDTO.fromJson(result.data as Map<String, dynamic>);
  }
}

@RestApi()
abstract class _AuthApiDataSource {
  factory _AuthApiDataSource(LogPassDio dio) = __AuthApiDataSource;

  @POST('/auth/users/login-attempts/')
  Future<InitializeLoginResultDTO> initializeLoginProcess(@Body() InitializeLoginDTO body);

  @DELETE('/auth/users/login-attempts/{loginAttemptId}/')
  Future<void> abortLoginProcess(@Path('loginAttemptId') String attemptId);

  @DELETE('/users/login-attempts/{tokenId}/')
  Future<void> revokeAccessToken(@Path('tokenId') String tokenId);
}
