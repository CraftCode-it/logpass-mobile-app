import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/push_notifications/push_notifications_repository.dart';

@Injectable()
class MarkFirebaseNotificationAsReceivedUseCase {
  final PushNotificationsRepository _pushNotificationAttemptRepository;
  MarkFirebaseNotificationAsReceivedUseCase(this._pushNotificationAttemptRepository);

  Future<void> call(IncomingAction incomingAction) async {
    final id = incomingAction.actionId;
    if(incomingAction.isFromFirebase && id != null) {
      await _pushNotificationAttemptRepository.markNotificationAsReceived(id);
    }
  }
}