import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/service/data/services_bundle.dart';
import 'package:logpass_me/domain/service/service_repository.dart';

@Injectable()
class GetPageOfServicesUseCase {
  final ServiceRepository _serviceRepository;

  GetPageOfServicesUseCase(this._serviceRepository);

  Future<ServicesBundle> call(int page) => _serviceRepository.getPageOfServices(page);
}
