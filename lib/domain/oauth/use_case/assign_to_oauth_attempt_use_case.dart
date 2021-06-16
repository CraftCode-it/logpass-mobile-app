import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/oauth/oauth_repository.dart';

@injectable
class AssignToOAuthAttemptUseCase {
  final OAuthRepository _repository;

  AssignToOAuthAttemptUseCase(this._repository);

  Future<void> call(String authorizationAttemptId) async {
    // TODO: add new store from which phone number will be read
    final phoneNumber = '+48123456789';
    return _repository.assignToOAuthAttempt(authorizationAttemptId, phoneNumber);
  }
}
