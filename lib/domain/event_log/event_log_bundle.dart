import 'package:logpass_me/domain/event_log/event_log.dart';

class EventLogBundle {
  final int totalCount;
  final List<EventLog> eventLogList;

  EventLogBundle(this.totalCount, this.eventLogList);
}