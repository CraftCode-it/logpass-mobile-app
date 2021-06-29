import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';

abstract class QueuedIncomingActionRepository {
  Future<void> queueIncomingAction(IncomingAction action);

  Future<IncomingAction?> popIncomingAction();
}
