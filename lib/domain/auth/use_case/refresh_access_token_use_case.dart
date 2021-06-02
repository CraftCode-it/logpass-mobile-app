import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/auth/auth_exception.dart';
import 'package:logpass_me/domain/auth/auth_store.dart';
import 'package:logpass_me/domain/auth/refresh_token_repository.dart';

@Injectable()
class RefreshAccessTokenUseCase {
  final RefreshTokenRepository _refreshTokenRepository;
  final AuthStore _authStore;

  RefreshAccessTokenUseCase(this._refreshTokenRepository, this._authStore);

  Future<void> call() async {
    final tokens = await _authStore.loadUserTokens();

    if (tokens == null) throw AuthException.notSignedIn();

    final refreshedTokens = await _refreshTokenRepository.refreshUserTokens(tokens.refreshToken);
    await _authStore.saveUserTokens(refreshedTokens);
  }
}
