import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/service/data/session/service_session.dart';
import 'package:logpass_me/domain/service/service_repository.dart';

@Injectable()
class EndSessionUseCase {
  final ServiceRepository _serviceRepository;

  EndSessionUseCase(this._serviceRepository);

  Future<void> call(ServiceSession session) async => _serviceRepository.endSession(session);
}
