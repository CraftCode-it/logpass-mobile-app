import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'logout_state.freezed.dart';

@freezed
class LogoutState with _$LogoutState {
  @Implements(BuildState)
  factory LogoutState.idle() = LogoutStateIdle;

  factory LogoutState.logout() = LogoutStateLogout;

  factory LogoutState.securedLogin() = LogoutStateSecuredLogin;
}
