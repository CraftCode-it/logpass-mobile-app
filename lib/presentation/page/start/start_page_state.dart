import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/domain/auth/sign_up/sign_up_verification.dart';
import 'package:logpass_me/presentation/page/start/start_page_cubit.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'start_page_state.freezed.dart';

@freezed
class StartPageState with _$StartPageState {
  @Implements(BuildState)
  factory StartPageState.initial() = _StartPageStateInitial;

  @Implements(BuildState)
  factory StartPageState.idle(bool isValid, List<StartPageError> formErrors) = _StartPageStateIdle;

  @Implements(BuildState)
  factory StartPageState.processing() = _StartPageStateProcessing;

  factory StartPageState.successOTP(SignUpVerification verification) = _StartPageStateSuccessOTP;

  factory StartPageState.successSignature() = _StartPageStateSuccessSignature;

  factory StartPageState.error() = _StartPageStateError;
}
