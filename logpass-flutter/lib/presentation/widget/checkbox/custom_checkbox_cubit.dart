import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/theme/theme_brightness.dart';
import 'package:logpass_me/domain/theme/use_case/get_theme_brightness_use_case.dart';
import 'package:logpass_me/presentation/widget/checkbox/custom_checkbox_state.dart';

@Injectable()
class CustomCheckboxCubit extends Cubit<CustomCheckboxState> {
  final GetThemeBrightnessUseCase _getThemeBrightnessUseCase;

  late bool _value;
  late ThemeBrightness _brightness;

  CustomCheckboxCubit(this._getThemeBrightnessUseCase) : super(CustomCheckboxState.loading());

  Future<void> init(bool initialValue) async {
    _brightness = await _getThemeBrightnessUseCase();
    set(initialValue);
  }

  void set(bool value) {
    _value = value;
    emit(CustomCheckboxState.value(_value, _brightness));
  }
}
