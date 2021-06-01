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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignUpVerification &&
          runtimeType == other.runtimeType &&
          verificationMethod == other.verificationMethod &&
          verificationUrl == other.verificationUrl &&
          toSign == other.toSign;

  @override
  int get hashCode => verificationMethod.hashCode ^ verificationUrl.hashCode ^ toSign.hashCode;
}
