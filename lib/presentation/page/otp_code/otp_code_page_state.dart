import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'otp_code_page_state.freezed.dart';

@freezed
class OTPCodePageState with _$OTPCodePageState {
  @Implements(BuildState)
  factory OTPCodePageState.loading() = _OTPCodePageStateLoading;

  @Implements(BuildState)
  factory OTPCodePageState.idle(
    String code,
    bool valid,
    DateTime resendAvailabilityTimestamp,
  ) = _OTPCodePageStateIdle;

  @Implements(BuildState)
  factory OTPCodePageState.processing(String code) = _OTPCodePageStateProcessing;

  factory OTPCodePageState.success() = _OTPCodePageStateSuccess;

  factory OTPCodePageState.error() = _OTPCodePageStateError;
}
