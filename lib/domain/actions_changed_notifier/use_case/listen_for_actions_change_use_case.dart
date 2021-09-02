import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/actions_changed_notifier/actions_changed_notifier.dart';

@Injectable()
class ListenForActionsChangeUseCase {
  final ActionsChangedNotifier _actionsChangedNotifier;

  ListenForActionsChangeUseCase(this._actionsChangedNotifier);

  Stream<String> call() => _actionsChangedNotifier.listen();
}
