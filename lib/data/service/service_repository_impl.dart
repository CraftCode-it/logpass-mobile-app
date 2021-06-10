import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/networking/error/dio_error_resolver.dart';
import 'package:logpass_me/data/service/api/data/authorized_services/authorized_services_response_dto.dart';
import 'package:logpass_me/data/service/api/service_api_data_source.dart';
import 'package:logpass_me/domain/service/data/services_bundle.dart';
import 'package:logpass_me/domain/service/service_repository.dart';

@LazySingleton(as: ServiceRepository)
class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceApiDataSource _serviceApiDataSource;
  final ServiceBundleDTOMapper _serviceBundleDTOMapper;

  ServiceRepositoryImpl(this._serviceApiDataSource, this._serviceBundleDTOMapper);

  @override
  Future<ServicesBundle> getPageOfServices(int page) async {
    final responseEntity = await callWithDioErrorResolver(() => _serviceApiDataSource.getServiceList(page));
    final servicesBundle = _serviceBundleDTOMapper(responseEntity);
    return servicesBundle;
  }
}
