import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'add_new_device_code_page_state.freezed.dart';

@freezed
class AddNewDeviceCodePageState with _$AddNewDeviceCodePageState {
  @Implements(BuildState)
  factory AddNewDeviceCodePageState.loading() = _AddNewDeviceCodePageStateLoading;

  @Implements(BuildState)
  factory AddNewDeviceCodePageState.idle(String code) = _AddNewDeviceCodePageStateCode;

  @Implements(BuildState)
  factory AddNewDeviceCodePageState.error() = _AddNewDeviceCodePageStateError;
}
