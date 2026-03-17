import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/domain/service/service_repository.dart';

@injectable
class GetServiceDetailsUseCase {
  final ServiceRepository _serviceRepository;

  GetServiceDetailsUseCase(this._serviceRepository);

  Future<Service> call(String clientId) => _serviceRepository.getServiceDetails(clientId);
}
