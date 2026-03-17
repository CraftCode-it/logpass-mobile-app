import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_actions_from_background_repository.dart';

@injectable
class SubscribeToIncomingActionsFromBackgroundUseCase {
  final IncomingActionsFromBackgroundRepository _actionsFromBackgroundRepository;

  SubscribeToIncomingActionsFromBackgroundUseCase(this._actionsFromBackgroundRepository);

  Stream<IncomingAction> call() => _actionsFromBackgroundRepository.listenForIncomingActions();
}
