import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/networking/log_pass_dio.dart';
import 'package:logpass_me/data/oauth/dtos/oauth_application_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'oauth_api_data_source.g.dart';

@LazySingleton()
@RestApi()
abstract class OAuthApiDataSource {
  @factoryMethod
  factory OAuthApiDataSource(LogPassDio dio) = _OAuthApiDataSource;

  @GET('/auth/o/authorization-attempts/{authorizationAttemptId}/')
  Future<OAuthApplicationDTO> getOAuthApplicationDetails(@Path('authorizationAttemptId') String authorizationAttemptId);
}
