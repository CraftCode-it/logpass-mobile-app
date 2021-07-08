import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/presentation/page/add_new_device/add_new_device_page_state.dart';

@injectable
class AddNewDevicePageCubit extends Cubit<AddNewDevicePageState> {
  static const otpCodeLength = 6;

  String _code = '';

  AddNewDevicePageCubit() : super(AddNewDevicePageState.idle(false));

  void updateCode(String code) {
    _code = code.replaceAll(r'-', '');

    _emitIdleState();
  }

  Future<void> addNewDevice() async {
    emit(AddNewDevicePageState.processing());

    try {
      // TODO: uncomment after backend impl of adding new device
      // emit(AddNewDevicePageState.deviceAdded());
    } on GeneralConnectionError catch (e) {
      _emitIdleState();
      await Future.delayed(const Duration(milliseconds: 200));
      emit(AddNewDevicePageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Device adding has failed', ex: e, stacktrace: s);
      _emitIdleState();
      await Future.delayed(const Duration(milliseconds: 200));
      emit(AddNewDevicePageState.error());
    }
  }

  void _emitIdleState() {
    final isCodeValid = _code.length == otpCodeLength;
    emit(AddNewDevicePageState.idle(isCodeValid));
  }
}
