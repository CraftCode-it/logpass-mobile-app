import 'package:logpass_me/domain/oauth/oauth_application.dart';

abstract class OAuthRepository {
  Future<OAuthApplication> getOAuthApplicationDetails(String authorizationAttemptId);
}
