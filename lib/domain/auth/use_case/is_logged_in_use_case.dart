import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/auth/auth_store.dart';

@Injectable()
class IsLoggedInUseCase {
  final AuthStore _authStore;

  IsLoggedInUseCase(this._authStore);

  Future<bool> call() async => await _authStore.loadUserTokens() != null;
}
