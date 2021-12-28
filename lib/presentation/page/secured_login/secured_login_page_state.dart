import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/domain/app_security/app_security_type.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'secured_login_page_state.freezed.dart';

@freezed
class SecuredLoginPageState with _$SecuredLoginPageState {
  @Implements<BuildState>()
  factory SecuredLoginPageState.idle(AppSecurityType type, bool pinCodeError) = _SecuredLoginPageStateIdle;

  @Implements<BuildState>()
  factory SecuredLoginPageState.processing() = _SecuredLoginPageStateProcessing;

  factory SecuredLoginPageState.validated() =  _SecuredLoginPageStateValidated;

  factory SecuredLoginPageState.connectionError(GeneralConnectionError error) = _SecuredLoginPageStateConnectionError;

  factory SecuredLoginPageState.error() = _SecuredLoginPageStateError;

  factory SecuredLoginPageState.loggingOut() = _SecuredLoginPageStateLoggingOut;

  factory SecuredLoginPageState.loggedOut() = _SecuredLoginPageStateLoggedOut;
}
