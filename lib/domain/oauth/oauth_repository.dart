import 'package:logpass_me/domain/oauth/data/approve_attempt_args.dart';
import 'package:logpass_me/domain/oauth/data/approved_confirmation.dart';
import 'package:logpass_me/domain/oauth/data/denied_confirmation.dart';
import 'package:logpass_me/domain/oauth/data/oauth_application.dart';

abstract class OAuthRepository {
  Future<OAuthApplication> getOAuthApplicationDetails(String authorizationAttemptId);

  Future<void> assignToOAuthAttempt(String authorizationAttemptId, String phoneNumber);

  Future<DeniedConfirmation> denyOAuthAttempt(String authorizationAttemptId);

  Future<ApprovedConfirmation> approveOAuthAttempt(
    String authorizationAttemptId,
    String tokenSub,
    ApproveAttemptArgs args,
  );
}
