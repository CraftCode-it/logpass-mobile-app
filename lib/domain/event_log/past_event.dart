import 'package:logpass_me/domain/incoming_actions/action_type.dart';

class PastEvent {
  final String serviceName;
  final String logo;
  final ActionType actionType;
  final DateTime dateTime;

  PastEvent({
    required this.serviceName,
    required this.logo,
    required this.actionType,
    required this.dateTime,
  });
}
