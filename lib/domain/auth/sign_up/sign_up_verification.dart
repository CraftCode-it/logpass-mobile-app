import 'package:logpass_me/domain/auth/verification_method.dart';

class SignUpVerification {
  final VerificationMethod verificationMethod;
  final String verificationUrl;
  final String? toSign;

  SignUpVerification(
    this.verificationMethod,
    this.verificationUrl,
    this.toSign,
  );
}
