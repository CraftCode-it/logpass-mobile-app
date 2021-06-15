import 'package:logpass_me/domain/oauth/denied_confirmation.dart';
import 'package:logpass_me/domain/oauth/oauth_application.dart';

abstract class OAuthRepository {
  Future<OAuthApplication> getOAuthApplicationDetails(String authorizationAttemptId);

  Future<void> assignToOAuthAttempt(String authorizationAttemptId, String phoneNumber);

  Future<DeniedConfirmation> denyOAuthAttempt(String authorizationAttemptId);
}
