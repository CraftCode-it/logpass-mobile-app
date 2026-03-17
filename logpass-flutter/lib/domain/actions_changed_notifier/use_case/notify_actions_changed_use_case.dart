import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/actions_changed_notifier/actions_changed_notifier.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';

@Injectable()
class NotifyActionsChangedUseCase {
  final ActionsChangedNotifier _actionsChangedNotifier;

  NotifyActionsChangedUseCase(this._actionsChangedNotifier);

  void call(IncomingAction incomingAction) => _actionsChangedNotifier.notify(incomingAction);
}
