import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/oauth/data/oauth_application.dart';
import 'package:logpass_me/domain/oauth/oauth_repository.dart';

@Injectable()
class InitUserAuthUseCase {
  final OAuthRepository _repository;

  InitUserAuthUseCase(this._repository);

  Future<OAuthApplication> call(Map<String, String> authorizationData) =>
      _repository.initializeUserAuth(authorizationData);
}
