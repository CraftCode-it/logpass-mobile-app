import 'package:logpass_me/domain/service/data/services_bundle.dart';
import 'package:logpass_me/domain/service/data/session/service_sessions_bundle.dart';

abstract class ServiceRepository {
  Future<ServicesBundle> getPageOfServices(int page);

  Future<ServiceSessionsBundle> getPageOfSessions(int page, String clientId, bool active);
}
