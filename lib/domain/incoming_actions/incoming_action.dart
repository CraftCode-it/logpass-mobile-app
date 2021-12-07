import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';

import 'package:logpass_me/domain/incoming_actions/action_type.dart';

class IncomingAction {
  final bool isFromFirebase;
  final ActionType actionType;
  final String? actionId;
  final DateTime expirationTime;
  final Map<String, String>? queryParameters;

  const IncomingAction._(this.actionType, this.actionId, this.queryParameters, this.expirationTime, this.isFromFirebase);

  factory IncomingAction.createFromFirebase(
    ActionType actionType,
    String? actionId,
    Map<String, String>? queryParameters,
  ) => IncomingAction._(
        actionType,
        actionId,
        queryParameters,
        clock.now().add(const Duration(minutes: 5)),
        true
      );

  factory IncomingAction.createFromWebSocket(
    ActionType actionType,
    String? actionId,
    Map<String, String>? queryParameters,
  ) => IncomingAction._(
        actionType,
        actionId,
        queryParameters,
        clock.now().add(const Duration(minutes: 5)),
        false
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IncomingAction &&
        other.actionType == actionType &&
        other.actionId == actionId &&
        mapEquals(other.queryParameters, queryParameters);
  }

  @override
  int get hashCode => actionType.hashCode ^ actionId.hashCode ^ queryParameters.hashCode;

  bool get isExpired {
    final now = DateTime.now();
    return now.millisecondsSinceEpoch >= expirationTime.millisecondsSinceEpoch;
  }
}
