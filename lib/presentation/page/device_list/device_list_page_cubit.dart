import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/device/device.dart';
import 'package:logpass_me/domain/device/use_case/get_device_list_use_case.dart';
import 'package:logpass_me/domain/device/use_case/update_device_list_use_case.dart';
import 'package:logpass_me/presentation/page/device_list/device_list_page_state.dart';

@injectable
class DeviceListPageCubit extends Cubit<DeviceListPageState> {
  final GetDeviceListUseCase _getDeviceListUseCase;
  final UpdateDeviceListUseCase _updateDeviceListUseCase;

  late List<Device> _originalDeviceList;
  late List<Device> _devices;

  DeviceListPageCubit(
    this._getDeviceListUseCase,
    this._updateDeviceListUseCase,
  ) : super(DeviceListPageState.loading());

  Future<void> initialize() async {
    _originalDeviceList = await _getDeviceListUseCase();
    _devices = List.of(_originalDeviceList);
    emit(DeviceListPageState.idle(_originalDeviceList, false));
  }

  void changeName(Device device, String newName) {
    final modifiedDeviceList = List.of(_devices);
    final modifiedDevice = device.copyWith(name: newName);
    final modifiedDeviceIndex = modifiedDeviceList.indexWhere((element) => element.id == device.id);

    if (modifiedDeviceIndex != -1) {
      modifiedDeviceList[modifiedDeviceIndex] = modifiedDevice;
      _devices = modifiedDeviceList;
      _emitIdleState();
    }
  }

  void remove(Device device) {
    final modifiedDeviceList = List.of(_devices);
    final removedDeviceIndex = modifiedDeviceList.indexWhere((element) => element.id == device.id);

    if (removedDeviceIndex != -1) {
      modifiedDeviceList.removeAt(removedDeviceIndex);
      _devices = modifiedDeviceList;
      _emitIdleState();
    }
  }

  Future<void> saveChanges() async {
    emit(DeviceListPageState.loading());

    await _updateDeviceListUseCase();
    _originalDeviceList = List.of(_devices);

    _emitIdleState();
  }

  void _emitIdleState() {
    emit(
      DeviceListPageState.idle(
        _devices,
        !const DeepCollectionEquality().equals(_originalDeviceList, _devices),
      ),
    );
  }
}
