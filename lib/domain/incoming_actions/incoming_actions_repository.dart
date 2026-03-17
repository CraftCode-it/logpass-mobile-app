import 'package:logpass_me/domain/common/clearable.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';

abstract class IncomingActionsRepository implements Clearable {
  Stream<IncomingAction> listenForIncomingActions();
}
