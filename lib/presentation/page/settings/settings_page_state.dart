import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'settings_page_state.freezed.dart';

@freezed
class SettingsPageState with _$SettingsPageState {
  @Implements<BuildState>()
  factory SettingsPageState.idle() = _SettingsPageStateIdle;

  factory SettingsPageState.loggingOut() = _SettingsPageStateLoggingOut;

  factory SettingsPageState.connectionError(GeneralConnectionError error) = _SettingsPageStateConnectionError;

  factory SettingsPageState.error() = _SettingsPageStateError;
}
