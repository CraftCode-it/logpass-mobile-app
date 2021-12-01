import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/push_notifications/push_notifications_repository.dart';

@Injectable()
class MarkFirebaseNotificationAsReceivedUseCase {
  final PushNotificationsRepository _pushNotificationAttemptRepository;
  MarkFirebaseNotificationAsReceivedUseCase(this._pushNotificationAttemptRepository);

  Future<void> call(String notificationId) async =>
      await _pushNotificationAttemptRepository.markNotificationAsReceived(notificationId);
}