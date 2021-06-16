import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/oauth/data/oauth_application.dart';
import 'package:logpass_me/domain/oauth/oauth_repository.dart';

@injectable
class GetOAuthApplicationDetailsUseCase {
  final OAuthRepository _repository;

  GetOAuthApplicationDetailsUseCase(this._repository);

  Future<OAuthApplication> call(String authorizationAttemptId) =>
      _repository.getOAuthApplicationDetails(authorizationAttemptId);
}
