import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_with_splitted_actions_repository.dart';

@injectable
class SubscribeToIncomingActionsUseCase {
  final IncomingWithSplittedActionsRepository _repository;

  SubscribeToIncomingActionsUseCase(this._repository);

  Stream<IncomingAction> call() => _repository.listenForIncomingActions();
}
