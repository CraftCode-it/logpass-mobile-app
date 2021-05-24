import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/auth/forced_logout_service.dart';

@Injectable()
class ListenForLogoutEventUseCase {
  final ForcedLogoutService _forcedLogoutService;

  ListenForLogoutEventUseCase(this._forcedLogoutService);

  Stream<void> call() => _forcedLogoutService.logoutEventStream;
}
