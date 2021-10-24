import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/domain/app_security/app_security_type.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'security_settings_page_state.freezed.dart';

@freezed
class SecuritySettingsPageState with _$SecuritySettingsPageState {
  @Implements(BuildState)
  factory SecuritySettingsPageState.loading() = _SecuritySettingsPageStateLoading;

  @Implements(BuildState)
  factory SecuritySettingsPageState.idle(AppSecurityType appSecurityType) = _SecuritySettingsPageStateIdle;

  factory SecuritySettingsPageState.setCode(AppSecurityType type) = _SecuritySettingsPageStateSetCode;

  factory SecuritySettingsPageState.biometricNotAvailable() = _SecuritySettingsPageStateBiometricNotAvailable;

  factory SecuritySettingsPageState.confirmWithCode(AppSecurityType type) = _SecuritySettingsPageStateConfirmWithCode;
}
