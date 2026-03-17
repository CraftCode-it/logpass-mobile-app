import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/auth/logout_service.dart';

@Injectable()
class ListenForLogoutEventUseCase {
  final LogoutService _logoutService;

  ListenForLogoutEventUseCase(this._logoutService);

  Stream<void> call() => _logoutService.logoutEventStream;
}
