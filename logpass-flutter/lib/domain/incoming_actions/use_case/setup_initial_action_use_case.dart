import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/incoming_actions/action_type.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_actions_from_link_repository.dart';
import 'package:logpass_me/domain/incoming_actions/queued_incoming_action_repository.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_message.dart';
import 'package:logpass_me/domain/push_notifications/push_notifications_repository.dart';

@injectable
class SetupInitialActionUseCase {
  final QueuedIncomingActionRepository _queuedIncomingActionRepository;
  final IncomingActionsFromLinkRepository _incomingActionsFromLinkRepository;
  final PushNotificationsRepository _pushNotificationsRepository;

  SetupInitialActionUseCase(
    this._queuedIncomingActionRepository,
    this._incomingActionsFromLinkRepository,
    this._pushNotificationsRepository,
  );

  Future<void> call() async {
    final action = await _incomingActionsFromLinkRepository.getInitialAction();
    final pushAction = await _pushNotificationsRepository.initialMessage();

    if (action != null) {
      await _queuedIncomingActionRepository.queueIncomingAction(action);
    } else if (pushAction != null) {
      await _resolvePushAction(pushAction);
    }
  }

  Future<void> _resolvePushAction(PushNotificationMessage pushAction) async {
    await pushAction.maybeMap(
      authorize: (authorize) async {
        await _queuedIncomingActionRepository.queueIncomingAction(
          IncomingAction.create(ActionType.authorize(), authorize.data.id, pushAction.sendAttemptId, null),
        );
      },
      orElse: () async {},
    );
  }
}