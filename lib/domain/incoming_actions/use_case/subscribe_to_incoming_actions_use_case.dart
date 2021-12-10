import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_with_splitted_actions_repository.dart';

@injectable
class SubscribeToIncomingActionsUseCase {
  final IncomingWithSplittedActionsRepository _incomingActionsRepository;

  SubscribeToIncomingActionsUseCase(
    this._incomingActionsRepository,
  );

  Stream<IncomingAction> call() => _incomingActionsRepository.listenForIncomingActions();
}
