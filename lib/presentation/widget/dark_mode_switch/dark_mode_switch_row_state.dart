import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/domain/theme/theme_brightness.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'dark_mode_switch_row_state.freezed.dart';

@freezed
class DarkModeSwitchRowState with _$DarkModeSwitchRowState {
  @Implements(BuildState)
  factory DarkModeSwitchRowState.loading() = _DarkModeSwitchRowStateLoading;

  @Implements(BuildState)
  factory DarkModeSwitchRowState.idle(ThemeBrightness themeBrightness) = _DarkModeSwitchRowStateIdle;
}
