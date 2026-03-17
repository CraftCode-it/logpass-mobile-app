import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/theme/theme_brightness.dart';
import 'package:logpass_me/domain/theme/use_case/get_theme_brightness_use_case.dart';
import 'package:logpass_me/domain/theme/use_case/set_theme_brightness_use_case.dart';
import 'package:logpass_me/presentation/widget/dark_mode_switch/dark_mode_switch_row_state.dart';

@injectable
class DarkModeSwitchRowCubit extends Cubit<DarkModeSwitchRowState> {
  final GetThemeBrightnessUseCase _getThemeBrightnessUseCase;
  final SetThemeBrightnessUseCase _setThemeBrightnessUseCase;

  late ThemeBrightness _brightness;

  DarkModeSwitchRowCubit(
    this._getThemeBrightnessUseCase,
    this._setThemeBrightnessUseCase,
  ) : super(DarkModeSwitchRowState.loading());

  Future<void> initialize() async {
    _brightness = await _getThemeBrightnessUseCase();
    emit(DarkModeSwitchRowState.idle(_brightness));
  }

  Future<void> changeToDarkMode() async {
    _brightness = ThemeBrightness.dark;
    await _setThemeBrightnessUseCase(_brightness);
    emit(DarkModeSwitchRowState.idle(_brightness));
  }

  Future<void> changeToLightMode() async {
    _brightness = ThemeBrightness.light;
    await _setThemeBrightnessUseCase(_brightness);
    emit(DarkModeSwitchRowState.idle(_brightness));
  }
}
