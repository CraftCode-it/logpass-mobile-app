import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/incoming_actions/action_type.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_actions_repository.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/one_time_code/one_time_code_repository.dart';
import 'package:logpass_me/domain/push_notifications/push_notifications_repository.dart';

@injectable
class SubscribeToIncomingActionsUseCase {
  final OneTimeCodeRepository _oneTimeCodeRepository;
  final IncomingActionsRepository _incomingActionsRepository;
  final PushNotificationsRepository _pushNotificationsRepository;

  SubscribeToIncomingActionsUseCase(
    this._oneTimeCodeRepository,
    this._incomingActionsRepository,
    this._pushNotificationsRepository
  );

  Stream<IncomingAction> call() => _incomingActionsRepository.listenForIncomingActions()
      .asyncMap(_findNotificationNotForUser)
      .where((event) => event != null)
      .map((event) => event!);

  Future<IncomingAction?> _findNotificationNotForUser(IncomingAction incomingAction) async {
    if(incomingAction.actionType == ActionType.refreshUserCode()) {
      final sendAttemptId = incomingAction.sendAttemptId;
      await _markAsReceived(sendAttemptId);
      await _refreshUserCode();
      return null;
    }

    return incomingAction;
  }

  Future<void> _markAsReceived(String? sendAttemptId) async {
    try {
      if(sendAttemptId != null) {
        await _pushNotificationsRepository.markNotificationAsReceived(sendAttemptId);
      }
    } on GeneralConnectionError catch (e) {
      Fimber.e('There is problem with internet connection', ex: e);
    } catch (e, s) {
      Fimber.e('Failed to marking notification as received', ex: e, stacktrace: s);
    }
  }

  Future<void> _refreshUserCode() async {
    try {
      await _oneTimeCodeRepository.loadOneTimeCode(true);
    } on GeneralConnectionError catch (e) {
      Fimber.e('There is problem with internet connection', ex: e);
    } catch (e, s) {
      Fimber.e('Failed to refresh user code', ex: e, stacktrace: s);
    }
  }
}
