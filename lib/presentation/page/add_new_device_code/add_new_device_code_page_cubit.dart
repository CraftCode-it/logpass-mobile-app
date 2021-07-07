import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/device/use_case/get_new_device_code_use_case.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/presentation/page/add_new_device_code/add_new_device_code_page_state.dart';

@injectable
class AddNewDeviceCodePageCubit extends Cubit<AddNewDeviceCodePageState> {
  final GetNewDeviceCodeUseCase _getNewDeviceCodeUseCase;

  AddNewDeviceCodePageCubit(this._getNewDeviceCodeUseCase) : super(AddNewDeviceCodePageState.loading());

  Future<void> initialize() async {
    await loadCode();
  }

  Future<void> loadCode() async {
    emit(AddNewDeviceCodePageState.loading());

    try {
      final code = await _getNewDeviceCodeUseCase();
      emit(AddNewDeviceCodePageState.idle(code));
    } on GeneralConnectionError {
      emit(AddNewDeviceCodePageState.error());
    } catch (e, s) {
      Fimber.e('Loading new device code failed', ex: e, stacktrace: s);
      emit(AddNewDeviceCodePageState.error());
    }
  }
}
