import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/push_notifications/push_notifications_repository.dart';

@Injectable()
class InitNotificationsServicesUseCase {
  final PushNotificationsRepository _repository;

  InitNotificationsServicesUseCase(this._repository);

  Future<void> call() => _repository.initNotificationsServices();
}
