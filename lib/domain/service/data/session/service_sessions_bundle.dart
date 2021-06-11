import 'package:logpass_me/domain/service/data/session/service_session.dart';

class ServiceSessionsBundle {
  final int totalCount;
  final List<ServiceSession> sessions;

  ServiceSessionsBundle(this.totalCount, this.sessions);
}