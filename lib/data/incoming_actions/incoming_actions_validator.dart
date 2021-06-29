import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';

@lazySingleton
class IncomingActionsValidator {
  final Set<IncomingAction> _actions = {};

  bool canInvoke(IncomingAction action) => _actions.add(action);
}