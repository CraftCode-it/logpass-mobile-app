import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'custom_checkbox_state.freezed.dart';

@freezed
class CustomCheckboxState with _$CustomCheckboxState {
  @Implements(BuildState)
  factory CustomCheckboxState.loading() = _CustomCheckboxStateLoading;

  @Implements(BuildState)
  factory CustomCheckboxState.value(bool value) = _CustomCheckboxStateIdle;
}
