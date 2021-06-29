import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/incoming_actions/pre_login_action_handler.dart';

@injectable
class SwitchPreLoginActionHandlerUseCase {
  final PreLoginActionHandler _preLoginActionHandler;

  SwitchPreLoginActionHandlerUseCase(this._preLoginActionHandler);

  Future<void> call(bool enable) => enable ? _preLoginActionHandler.enable() : _preLoginActionHandler.disable();
}
