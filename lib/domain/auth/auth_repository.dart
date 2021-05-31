import 'package:logpass_me/domain/auth/sign_up/sign_up_verification.dart';
import 'package:logpass_me/domain/auth/token/user_tokens.dart';

abstract class AuthRepository {
  Future<SignUpVerification> signUp(String phoneNumber, String verifyKey, String publicKey);
}
