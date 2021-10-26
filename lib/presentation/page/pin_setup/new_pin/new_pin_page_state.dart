import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'new_pin_page_state.freezed.dart';

@freezed
class NewPinPageState with _$NewPinPageState {
  @Implements(BuildState)
  factory NewPinPageState.idle(String pin, bool valid) = _NewPinPageStateIdle;
}