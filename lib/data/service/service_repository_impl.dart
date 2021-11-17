import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/networking/error/dio_error_resolver.dart';
import 'package:logpass_me/data/service/api/data/authorized_services/authorized_services_response_dto.dart';
import 'package:logpass_me/data/service/api/data/service_dto.dart';
import 'package:logpass_me/data/service/api/data/session/service_session_list_response_dto.dart';
import 'package:logpass_me/data/service/api/service_api_data_source.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/domain/service/data/services_bundle.dart';
import 'package:logpass_me/domain/service/data/session/service_session.dart';
import 'package:logpass_me/domain/service/data/session/service_sessions_bundle.dart';
import 'package:logpass_me/domain/service/service_repository.dart';

@LazySingleton(as: ServiceRepository)
class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceApiDataSource _serviceApiDataSource;
  final ServiceBundleDTOMapper _serviceBundleDTOMapper;
  final ServiceSessionsBundleDTOMapper _serviceSessionsBundleDTOMapper;
  final ServiceDTOMapper _serviceDTOMapper;

  ServiceRepositoryImpl(
    this._serviceApiDataSource,
    this._serviceBundleDTOMapper,
    this._serviceSessionsBundleDTOMapper,
    this._serviceDTOMapper,
  );

  @override
  Future<ServicesBundle> getPageOfServices(int page) async {
    final responseDTO = await
    callWithDioErrorResolver(() => _serviceApiDataSource.getServiceList(page));
    final servicesBundle = _serviceBundleDTOMapper(responseDTO);
    return servicesBundle;
  }

  @override
  Future<ServiceSessionsBundle> getPageOfSessions(int page, String clientId, bool active) async {
    final responseDTO = await callWithDioErrorResolver(
      () => _serviceApiDataSource.getServiceTokenList(page, clientId: clientId, isActive: active),
    );
    final sessionsBundle = _serviceSessionsBundleDTOMapper(responseDTO);
    return sessionsBundle;
  }

  @override
  Future<void> endSession(ServiceSession session) async {
    await callWithDioErrorResolver(
      () => _serviceApiDataSource.endSession(session.id),
    );
  }
  @override
  Future<void> endAllSessions(Service service) async {
    await callWithDioErrorResolver(
      () => _serviceApiDataSource.endAllSessions(service.clientId),
    );
  }

  @override
  Future<Service> getServiceDetails(String clientId) async {
    final response = await callWithDioErrorResolver(
      () => _serviceApiDataSource.getServiceDetails(clientId),
    );

    return _serviceDTOMapper.to(response.data);
  }
}
