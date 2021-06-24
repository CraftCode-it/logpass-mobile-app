import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'settings_page_state.freezed.dart';

@freezed
class SettingsPageState with _$SettingsPageState {
  @Implements(BuildState)
  factory SettingsPageState.idle() = _SettingsPageStateIdle;

  factory SettingsPageState.loggingOut() = _SettingsPageStateLoggingOut;
}
