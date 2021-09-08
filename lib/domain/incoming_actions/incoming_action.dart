import 'package:flutter/foundation.dart';

import 'package:logpass_me/domain/incoming_actions/action_type.dart';

class IncomingAction {
  final ActionType actionType;
  final String? actionId;
  final Map<String, String>? queryParameters;

  IncomingAction(this.actionType, this.actionId, this.queryParameters);

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
}
