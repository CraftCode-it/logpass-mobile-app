import 'package:logpass_me/domain/incoming_actions/action_type.dart';

class IncomingAction {
  final ActionType actionType;
  final String actionId;

  IncomingAction(this.actionType, this.actionId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncomingAction &&
          runtimeType == other.runtimeType &&
          actionId == other.actionId &&
          actionType == other.actionType;

  @override
  int get hashCode => actionType.hashCode;
}
