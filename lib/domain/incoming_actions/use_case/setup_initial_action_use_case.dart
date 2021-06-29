import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_actions_from_link_repository.dart';
import 'package:logpass_me/domain/incoming_actions/queued_incoming_action_repository.dart';

@injectable
class SetupInitialActionUseCase {
  final QueuedIncomingActionRepository _queuedIncomingActionRepository;
  final IncomingActionsFromLinkRepository _incomingActionsFromLinkRepository;

  SetupInitialActionUseCase(
    this._queuedIncomingActionRepository,
    this._incomingActionsFromLinkRepository,
  );

  Future<void> call() async {
    final action = await _incomingActionsFromLinkRepository.getInitialAction();
    if (action != null) {
      await _queuedIncomingActionRepository.queueIncomingAction(action);
    }
  }
}
