import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'confirm_pin_page_state.freezed.dart';

@freezed
class ConfirmPinPageState with _$ConfirmPinPageState {
  @Implements(BuildState)
  factory ConfirmPinPageState.idle(bool valid, bool wrong) = _ConfirmPinPageStateIdle;

  @Implements(BuildState)
  factory ConfirmPinPageState.processing() = _ConfirmPinPageStateProcessing;

  factory ConfirmPinPageState.pinSaved() = _ConfirmPinPageStatePinSaved;
}