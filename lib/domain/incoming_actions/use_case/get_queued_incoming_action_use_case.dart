import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/queued_incoming_action_repository.dart';

@injectable
class GetQueuedIncomingActionUseCase {
  final QueuedIncomingActionRepository _queuedIncomingActionRepository;

  GetQueuedIncomingActionUseCase(this._queuedIncomingActionRepository);

  Future<IncomingAction?> call() => _queuedIncomingActionRepository.popIncomingAction();
}
