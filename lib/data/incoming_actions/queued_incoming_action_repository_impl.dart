import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/queued_incoming_action_repository.dart';

@LazySingleton(as: QueuedIncomingActionRepository)
class QueuedIncomingActionRepositoryImpl implements QueuedIncomingActionRepository {
  IncomingAction? _queuedAction;

  @override
  Future<IncomingAction?> popIncomingAction() async {
    final action = _queuedAction;
    _queuedAction = null;

    return action;
  }

  @override
  Future<void> queueIncomingAction(IncomingAction action) async {
    _queuedAction = action;
  }
}
