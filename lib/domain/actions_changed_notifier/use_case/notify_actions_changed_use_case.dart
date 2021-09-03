import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/actions_changed_notifier/actions_changed_notifier.dart';

@Injectable()
class NotifyActionsChangedUseCase {
  final ActionsChangedNotifier _actionsChangedNotifier;

  NotifyActionsChangedUseCase(this._actionsChangedNotifier);

  void call(String actionId) => _actionsChangedNotifier.notify(actionId);
}
