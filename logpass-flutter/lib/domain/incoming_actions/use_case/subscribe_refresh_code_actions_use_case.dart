import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_with_splitted_actions_repository.dart';

@injectable
class SubscribeToRefreshCodeActionsUseCase {
  final IncomingWithSplittedActionsRepository _incomingWithSplittedActionsRepository;

  SubscribeToRefreshCodeActionsUseCase(
    this._incomingWithSplittedActionsRepository,
  );

  Stream<IncomingAction> call() => _incomingWithSplittedActionsRepository.listenForIncomingRefreshCodeActions();
}
