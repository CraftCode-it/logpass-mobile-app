import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/networking/log_pass_dio.dart';
import 'package:logpass_me/data/service/api/data/authorized_services/authorized_services_response_dto.dart';
import 'package:logpass_me/data/service/api/data/session/service_session_list_response_dto.dart';
import 'package:retrofit/http.dart';

part 'service_api_data_source.g.dart';

@LazySingleton()
@RestApi()
abstract class ServiceApiDataSource {
  @factoryMethod
  factory ServiceApiDataSource(LogPassDio dio) = _ServiceApiDataSource;

  @GET('/users/self/authorized-applications/')
  Future<AuthorizedServicesResponseDTO> getServiceList(@Query('page') int page);

  @GET('/users/self/tokens/')
  Future<ServiceSessionListResponseDTO> getServiceTokenList(
    @Query('page_number') int pageNumber, {
    @Query('is_active') bool? isActive,
    @Query('client_id') String? clientId,
  });
}
