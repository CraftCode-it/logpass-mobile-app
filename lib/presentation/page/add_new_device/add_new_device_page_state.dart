import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'add_new_device_page_state.freezed.dart';

@freezed
class AddNewDevicePageState with _$AddNewDevicePageState {
  @Implements(BuildState)
  factory AddNewDevicePageState.idle(bool isCodeValid) = _AddNewDevicePageStateIdle;

  @Implements(BuildState)
  factory AddNewDevicePageState.processing() = _AddNewDevicePageStateProcessing;

  factory AddNewDevicePageState.connectionError(GeneralConnectionError error) = _AddNewDevicePageStateConnectionError;

  factory AddNewDevicePageState.error() = _AddNewDevicePageStateError;

  factory AddNewDevicePageState.deviceAdded() = _AddNewDeviceCodePageDeviceAdded;
}
