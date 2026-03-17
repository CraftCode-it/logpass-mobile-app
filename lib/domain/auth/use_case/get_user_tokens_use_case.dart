import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/auth/auth_exception.dart';
import 'package:logpass_me/domain/auth/auth_store.dart';
import 'package:logpass_me/domain/auth/token/user_tokens.dart';

@Injectable()
class GetUserTokensUseCase {
  final AuthStore _authStore;

  GetUserTokensUseCase(this._authStore);

  Future<UserTokens> call() async {
    final tokens = await _authStore.loadUserTokens();

    if (tokens == null) throw AuthException.notSignedIn();

    return tokens;
  }
}
