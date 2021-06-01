import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/presentation/widget/checkbox/custom_checkbox_state.dart';

@Injectable()
class CustomCheckboxCubit extends Cubit<CustomCheckboxState> {
  late bool _value;

  CustomCheckboxCubit() : super(CustomCheckboxState.loading());

  void set(bool value) {
    _value = value;
    emit(CustomCheckboxState.value(_value));
  }
}
