import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/oauth/denied_confirmation.dart';
import 'package:logpass_me/domain/oauth/oauth_repository.dart';

@injectable
class DenyOAuthAttemptUseCase {
  final OAuthRepository _repository;

  DenyOAuthAttemptUseCase(this._repository);

  Future<DeniedConfirmation> call(String authorizationAttemptId) =>
      _repository.denyOAuthAttempt(authorizationAttemptId);
}
