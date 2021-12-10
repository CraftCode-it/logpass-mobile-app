import 'package:logpass_me/domain/event_log/event_type.dart';

import 'logo_type.dart';

class EventLog {
  final LogoType logo;
  final EventType eventType;
  final DateTime dateTime;

  EventLog({
    required this.logo,
    required this.eventType,
    required this.dateTime,
  });
}
