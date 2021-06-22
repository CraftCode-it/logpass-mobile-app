import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_page_state.freezed.dart';

@freezed
class SettingsPageState with _$SettingsPageState {
  factory SettingsPageState.idle() = _SettingsPageStateIdle;
}