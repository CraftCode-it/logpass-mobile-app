import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_verification_error.freezed.dart';

@freezed
class LoginVerificationError with _$LoginVerificationError {
  factory LoginVerificationError.invalidCode(String message) = _LoginVerificationErrorInvalidCode;

  factory LoginVerificationError.accountAlreadyCreated() = _LoginVerificationErrorAccountAlreadyCreated;
}
