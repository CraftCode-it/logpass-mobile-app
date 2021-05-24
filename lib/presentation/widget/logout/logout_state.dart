import 'package:freezed_annotation/freezed_annotation.dart';

part 'logout_state.freezed.dart';

@freezed
class LogoutState with _$LogoutState {
  factory LogoutState.idle() = LogoutStateIdle;

  factory LogoutState.logout() = LogoutStateLogout;
}
