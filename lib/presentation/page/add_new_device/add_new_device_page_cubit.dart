import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/presentation/page/add_new_device/add_new_device_page_state.dart';

@injectable
class AddNewDevicePageCubit extends Cubit<AddNewDevicePageState> {
  String _code = '';

  AddNewDevicePageCubit() : super(AddNewDevicePageState.idle(false));

  void updateCode(String code) {
    _code = code.replaceAll(r'-', '');

    final isCodeValid = _code.length == 6;

    emit(AddNewDevicePageState.idle(isCodeValid));
  }

  Future<void> addNewDevice() async {
    emit(AddNewDevicePageState.processing());
  }
}
