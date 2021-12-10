import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/push_notifications/push_notifications_repository.dart';

@Injectable()
class MarkNotificationAsReceivedUseCase {
  final PushNotificationsRepository _pushNotificationAttemptRepository;
  MarkNotificationAsReceivedUseCase(this._pushNotificationAttemptRepository);

  Future<void> call(IncomingAction incomingAction) async {
    final sendAttemptId = incomingAction.sendAttemptId;
    if(sendAttemptId != null) {
      await _pushNotificationAttemptRepository.markNotificationAsReceived(sendAttemptId);
    }
  }
}