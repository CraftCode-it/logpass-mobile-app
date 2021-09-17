import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/domain/service/data/session/service_session.dart';
import 'package:logpass_me/domain/service/service_repository.dart';

@Injectable()
class EndAllSessionsUseCase {
  final ServiceRepository _serviceRepository;

  EndAllSessionsUseCase(this._serviceRepository);

  Future<void> call(Service service) async => _serviceRepository.endAllSessions(service);
}
