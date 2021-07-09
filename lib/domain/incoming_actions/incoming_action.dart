import 'package:logpass_me/domain/incoming_actions/action_type.dart';

class IncomingAction {
  final ActionType actionType;
  final String actionId;

  // TODO: adjust after backend implementation
  final String? content;

  IncomingAction(
    this.actionType,
    this.actionId, [
    this.content,
  ]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IncomingAction &&
        other.runtimeType == runtimeType &&
        other.actionType == actionType &&
        other.actionId == actionId &&
        other.content == content;
  }

  @override
  int get hashCode => actionType.hashCode ^ actionId.hashCode ^ content.hashCode;
}
