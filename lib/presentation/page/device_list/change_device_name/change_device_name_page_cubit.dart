import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/presentation/page/device_list/change_device_name/change_device_name_page_state.dart';

@injectable
class ChangeDeviceNamePageCubit extends Cubit<ChangeDeviceNamePageState> {
  late String _originalName;

  ChangeDeviceNamePageCubit() : super(ChangeDeviceNamePageState.initializing());

  void initialize(String currentName) {
    _originalName = currentName;
    emit(ChangeDeviceNamePageState.initializeName(_originalName));
    emit(ChangeDeviceNamePageState.idle(currentName, false));
  }

  void updateName(String name) {
    final canSave = name != _originalName && name.isNotEmpty;
    emit(ChangeDeviceNamePageState.idle(name, canSave));
  }
}
