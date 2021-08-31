import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/oauth/oauth_repository.dart';

@injectable
class AssignToOAuthAttemptUseCase {
  final OAuthRepository _repository;

  AssignToOAuthAttemptUseCase(this._repository);

  Future<void> call(String authorizationAttemptId, String phoneNumber) async {
    return _repository.assignToOAuthAttempt(authorizationAttemptId, phoneNumber);
  }
}
