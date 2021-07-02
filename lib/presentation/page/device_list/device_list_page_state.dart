import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/domain/device/device.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'device_list_page_state.freezed.dart';

@freezed
class DeviceListPageState with _$DeviceListPageState {
  @Implements(BuildState)
  factory DeviceListPageState.loading() = _DeviceListPageStateLoading;

  @Implements(BuildState)
  factory DeviceListPageState.idle(List<Device> deviceList, bool modified) = _DeviceListPageStateIdle;

  @Implements(BuildState)
  factory DeviceListPageState.loadingError() = _DeviceListPageStateError;

  factory DeviceListPageState.connectionError(GeneralConnectionError error) = _DeviceListPageStateConnectionError;
}
