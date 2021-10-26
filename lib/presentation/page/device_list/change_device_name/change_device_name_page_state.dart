import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'change_device_name_page_state.freezed.dart';

@freezed
class ChangeDeviceNamePageState with _$ChangeDeviceNamePageState {
  @Implements(BuildState)
  factory ChangeDeviceNamePageState.initializing() = _ChangeDeviceNamePageStateInitializing;

  @Implements(BuildState)
  factory ChangeDeviceNamePageState.idle(String name, bool canSave) = _ChangeDeviceNamePageStateIdle;

  factory ChangeDeviceNamePageState.initializeName(String name) = _ChangeDeviceNamePageStateInitializeName;
}
