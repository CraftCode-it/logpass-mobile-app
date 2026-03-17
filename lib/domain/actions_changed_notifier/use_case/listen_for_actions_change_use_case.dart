import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/actions_changed_notifier/actions_changed_notifier.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';

@Injectable()
class ListenForActionsChangeUseCase {
  final ActionsChangedNotifier _actionsChangedNotifier;

  ListenForActionsChangeUseCase(this._actionsChangedNotifier);

  Stream<IncomingAction> call() => _actionsChangedNotifier.listen();
}
