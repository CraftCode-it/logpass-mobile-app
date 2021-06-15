import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/auth/auth_exception.dart';
import 'package:logpass_me/domain/auth/auth_store.dart';
import 'package:logpass_me/domain/oauth/data/approve_attempt_args.dart';
import 'package:logpass_me/domain/oauth/data/approved_confirmation.dart';
import 'package:logpass_me/domain/oauth/oauth_repository.dart';

@injectable
class ApproveOAuthAttemptUseCase {
  final OAuthRepository _repository;
  final AuthStore _authStore;

  ApproveOAuthAttemptUseCase(this._repository, this._authStore);

  Future<ApprovedConfirmation> call(String authorizationAttemptId, ApproveAttemptArgs args) async {
    final tokens = await _authStore.loadUserTokens();

    if (tokens == null) throw AuthException.notSignedIn();

    return _repository.approveOAuthAttempt(authorizationAttemptId, tokens.sub, args);
  }
}
