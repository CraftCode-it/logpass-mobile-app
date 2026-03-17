import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/service/data/session/service_sessions_bundle.dart';
import 'package:logpass_me/domain/service/service_repository.dart';

@Injectable()
class GetPageOfServiceSessionsUseCase {
  final ServiceRepository _serviceRepository;

  GetPageOfServiceSessionsUseCase(this._serviceRepository);

  Future<ServiceSessionsBundle> call(int page, String clientId, bool active) =>
      _serviceRepository.getPageOfSessions(page, clientId, active);
}
