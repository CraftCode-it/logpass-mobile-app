import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/auth/logout_service.dart';
import 'package:logpass_me/domain/push_notifications/use_case/unregister_push_notification_device_use_case.dart';

@injectable
class LogoutWithoutListenableCallbackUseCase {
  final LogoutService _logoutService;
  final UnregisterPushNotificationDeviceUseCase _unregisterPushNotificationDeviceUseCase;

  LogoutWithoutListenableCallbackUseCase(
    this._logoutService,
    this._unregisterPushNotificationDeviceUseCase,
  );

  Future<void> call() async {
    await _unregisterPushNotificationDeviceUseCase();
    await _logoutService.logoutWithoutListenableCallback();
  }
}
