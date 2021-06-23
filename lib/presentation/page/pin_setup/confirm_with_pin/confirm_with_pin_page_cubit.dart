import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app_security/use_case/validate_pin_code_use_case.dart';
import 'package:logpass_me/presentation/page/pin_setup/app_pin_config.dart';
import 'package:logpass_me/presentation/page/pin_setup/confirm_with_pin/confirm_with_pin_page_state.dart';

@injectable
class ConfirmWithPinPageCubit extends Cubit<ConfirmWithPinPageState> {
  final ValidatePinCodeUseCase _validatePinCodeUseCase;

  late String _code;

  ConfirmWithPinPageCubit(this._validatePinCodeUseCase) : super(ConfirmWithPinPageState.idle(false, true));

  void updateCode(String code) {
    _code = code;

    if (code.length == appPinLength) {
      emit(ConfirmWithPinPageState.idle(true, true));
    } else {
      emit(ConfirmWithPinPageState.idle(false, true));
    }
  }

  Future<void> validate() async {
    final validCode = await _validatePinCodeUseCase(_code);
    if (validCode) {
      emit(ConfirmWithPinPageState.codeValidated());
    } else {
      emit(ConfirmWithPinPageState.idle(false, false));
    }
  }
}
