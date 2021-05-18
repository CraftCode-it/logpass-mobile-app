import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/auth/auth_exception.dart';
import 'package:logpass_me/domain/auth/auth_repository.dart';
import 'package:logpass_me/domain/auth/auth_store.dart';

@Injectable()
class RefreshAccessTokenUseCase {
  final AuthRepository _authRepository;
  final AuthStore _authStore;

  RefreshAccessTokenUseCase(this._authRepository, this._authStore);

  Future<void> call() async {
    final tokens = await _authStore.loadUserTokens();

    if (tokens == null) throw AuthException.notSignedIn();

    final refreshedTokens = await _authRepository.refreshUserTokens(tokens.refreshToken);
    await _authStore.saveUserTokens(refreshedTokens);
  }
}
