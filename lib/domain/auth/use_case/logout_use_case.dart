import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/auth/logout_service.dart';

@injectable
class LogoutUseCase {
  final LogoutService _logoutService;

  LogoutUseCase(this._logoutService);

  Future<void> call() async => _logoutService.logout();
}
