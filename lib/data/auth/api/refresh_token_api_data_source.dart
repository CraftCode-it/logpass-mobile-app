import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/auth/api/refresh/refresh_token_dto.dart';
import 'package:logpass_me/data/auth/api/verify/tokens_result_dto.dart';
import 'package:logpass_me/data/networking/log_pass_dio.dart';
import 'package:retrofit/retrofit.dart';

part 'refresh_token_api_data_source.g.dart';

@Singleton()
@RestApi()
abstract class RefreshTokenApiDataSource {
  @factoryMethod
  factory RefreshTokenApiDataSource(RefreshTokenDio dio) = _RefreshTokenApiDataSource;

  @POST('/users/self/tokens/refresh/')
  Future<TokensResultDTO> refreshAccessToken(@Body() RefreshTokenDTO body);
}
