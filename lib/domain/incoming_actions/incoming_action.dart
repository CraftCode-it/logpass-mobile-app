import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';

import 'package:logpass_me/domain/incoming_actions/action_type.dart';

class IncomingAction {
  final ActionType actionType;
  final String? actionId;
  final String? sendAttemptId;
  final DateTime expirationTime;
  final Map<String, String>? queryParameters;

  const IncomingAction._(this.actionType, this.actionId, this.sendAttemptId, this.queryParameters, this.expirationTime);

  factory IncomingAction.create(
    ActionType actionType,
    String? actionId,
    String? sendAttemptId,
    Map<String, String>? queryParameters,
  ) => IncomingAction._(
    actionType,
    actionId,
    sendAttemptId,
    queryParameters,
    clock.now().add(const Duration(minutes: 5)),
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    final isSameActionType = other is IncomingAction && other.actionType == actionType;
    final isSameActionId = other is IncomingAction && other.actionId == actionId;
    final isSameQueryParameters = other is IncomingAction && mapEquals(other.queryParameters, queryParameters);
    final isSameSendAttemptId = other is IncomingAction && other.sendAttemptId == sendAttemptId;

    return actionType.maybeWhen(
      authorize: () => isSameActionType && isSameActionId && isSameQueryParameters,
      orElse: () => isSameActionType && isSameActionId && isSameQueryParameters && isSameSendAttemptId
    );
  }

  @override
  int get hashCode => actionType.maybeWhen(
    authorize: () => actionType.hashCode ^ actionId.hashCode ^ queryParameters.hashCode,
    orElse: () => actionType.hashCode ^ actionId.hashCode ^ queryParameters.hashCode ^ sendAttemptId.hashCode
  );

  bool get isExpired {
    final now = DateTime.now();
    return now.millisecondsSinceEpoch >= expirationTime.millisecondsSinceEpoch;
  }
}
