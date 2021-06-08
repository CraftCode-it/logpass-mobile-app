import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app_security/use_case/save_pin_code_use_case.dart';
import 'package:logpass_me/presentation/page/pin_setup/confirm_pin/confirm_pin_page_state.dart';

@Injectable()
class ConfirmPinPageCubit extends Cubit<ConfirmPinPageState> {
  final SavePinCodeUseCase _savePinCodeUseCase;

  late String _pin;
  String? _pinConfirm;

  ConfirmPinPageCubit(this._savePinCodeUseCase) : super(ConfirmPinPageState.idle(false));

  void initialize(String pin) {
    _pin = pin;
  }

  void updatePin(String pin) {
    _pinConfirm = pin;

    final valid = _pin == _pinConfirm;
    emit(ConfirmPinPageState.idle(valid));
  }

  Future<void> savePin() async {
    emit(ConfirmPinPageState.processing());
    await _savePinCodeUseCase(_pin);
    emit(ConfirmPinPageState.pinSaved());
  }
}
