import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'otp_code_page_state.freezed.dart';

@freezed
class OTPCodePageState with _$OTPCodePageState {
  @Implements(BuildState)
  factory OTPCodePageState.loading() = _OTPCodePageStateLoading;

  @Implements(BuildState)
  factory OTPCodePageState.idle(
    String code,
    bool valid,
    DateTime resendAvailabilityTimestamp, {
    String? codeError,
  }) = _OTPCodePageStateIdle;

  @Implements(BuildState)
  factory OTPCodePageState.verifying(String code) = _OTPCodePageStateVeryfying;

  @Implements(BuildState)
  factory OTPCodePageState.resending(String code) = _OTPCodePageStateProcessingResending;

  factory OTPCodePageState.success() = _OTPCodePageStateSuccess;

  factory OTPCodePageState.resendSuccess() = _OTPCodePageStateResendSuccess;

  factory OTPCodePageState.otpAutofill(String code) = _OTPCodePageStateOTPAutofill;

  factory OTPCodePageState.accountAlreadyExists() = _OTPCodePageStateAccountAlreadyExists;

  factory OTPCodePageState.tooManyAttempts(String message) = _OTPCodePageStateTooManyAttempts;

  factory OTPCodePageState.connectionError(GeneralConnectionError error) = _OTPCodePageStateError;
}
