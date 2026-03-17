import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/presentation/page/pin_setup/app_pin_config.dart';
import 'package:logpass_me/presentation/page/pin_setup/new_pin/new_pin_page_state.dart';

@Injectable()
class NewPingPageCubit extends Cubit<NewPinPageState> {
  NewPingPageCubit() : super(NewPinPageState.idle('', false));

  void updatePin(String pin) {
    final valid = pin.length == appPinLength;
    emit(NewPinPageState.idle(pin, valid));
  }
}
