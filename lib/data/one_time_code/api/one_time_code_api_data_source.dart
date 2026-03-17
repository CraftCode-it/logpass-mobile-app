import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/networking/log_pass_dio.dart';
import 'package:logpass_me/data/one_time_code/dtos/one_time_code_dto.dart';
import 'package:logpass_me/data/one_time_code/dtos/one_time_code_parameter_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'one_time_code_api_data_source.g.dart';

@RestApi()
@singleton
abstract class OneTimeCodeApiDataSource {
  @factoryMethod
  factory OneTimeCodeApiDataSource(LogPassDio dio) = _OneTimeCodeApiDataSource;

  @POST('/users/self/code/')
  Future<OneTimeCodeDTO> getOneTimeCode(@Body() OneTimeCodeParameterDTO parameterDto);
}
