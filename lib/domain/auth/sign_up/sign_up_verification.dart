import 'package:logpass_me/domain/auth/verification_method.dart';

class SignUpVerification {
  final String phoneNumber;
  final VerificationMethod verificationMethod;
  final String verificationUrl;
  final String? toSign;

  SignUpVerification(
    this.phoneNumber,
    this.verificationMethod,
    this.verificationUrl,
    this.toSign,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignUpVerification &&
          runtimeType == other.runtimeType &&
          phoneNumber == other.phoneNumber &&
          verificationMethod == other.verificationMethod &&
          verificationUrl == other.verificationUrl &&
          toSign == other.toSign;

  @override
  int get hashCode => phoneNumber.hashCode ^ verificationMethod.hashCode ^ verificationUrl.hashCode ^ toSign.hashCode;
}
