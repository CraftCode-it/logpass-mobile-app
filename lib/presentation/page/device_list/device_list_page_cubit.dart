import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/device/use_case/get_device_list_use_case.dart';
import 'package:logpass_me/presentation/page/device_list/device_list_page_state.dart';

@injectable
class DeviceListPageCubit extends Cubit<DeviceListPageState> {
  final GetDeviceListUseCase _getDeviceListUseCase;

  DeviceListPageCubit(this._getDeviceListUseCase) : super(DeviceListPageState.loading());

  Future<void> initialize() async {
    final devices = await _getDeviceListUseCase();
    emit(DeviceListPageState.idle(devices));
  }
}
