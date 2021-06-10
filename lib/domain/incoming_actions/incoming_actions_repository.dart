import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';

abstract class IncomingActionsRepository {
  Stream<IncomingAction> listenForIncomingActions();
}
