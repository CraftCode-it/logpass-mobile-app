import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_actions_from_link_repository.dart';

@injectable
class SubscribeToIncomingActionsFromLinkUseCase {
  final IncomingActionsFromLinkRepository _incomingActionsFromLinkRepository;

  SubscribeToIncomingActionsFromLinkUseCase(this._incomingActionsFromLinkRepository);

  Stream<IncomingAction> call() => _incomingActionsFromLinkRepository.listenForIncomingActions();
}
