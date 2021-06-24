import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'confirm_with_pin_page_state.freezed.dart';

@freezed
class ConfirmWithPinPageState with _$ConfirmWithPinPageState {
  @Implements(BuildState)
  factory ConfirmWithPinPageState.idle(bool validLength, bool validCode) = _ConfirmWithPinPageStateIdle;

  factory ConfirmWithPinPageState.codeValidated() = _ConfirmWithPinPageStateCodeValidated;
}
