import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'get_safer_page_state.freezed.dart';

@freezed
class GetSaferPageState with _$GetSaferPageState {
  @Implements<BuildState>()
  factory GetSaferPageState.loading() = _GetSaferPageStateLoading;

  @Implements<BuildState>()
  factory GetSaferPageState.idle(bool withBiometrics) = _GetSaferPageStateIdle;

  factory GetSaferPageState.setCodeForBiometrics() = _GetSaferPageStateSetCodeForBiometrics;

  factory GetSaferPageState.success() = _GetSaferPageStateSuccess;
}
