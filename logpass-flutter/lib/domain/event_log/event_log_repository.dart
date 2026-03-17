import 'package:logpass_me/domain/event_log/event_log_bundle.dart';

abstract class EventLogRepository {
  Future<EventLogBundle> getPageOfEventLogs(int page);
}