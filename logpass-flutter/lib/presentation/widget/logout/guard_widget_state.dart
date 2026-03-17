import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'guard_widget_state.freezed.dart';

@freezed
class GuardWidgetState with _$GuardWidgetState {
  @Implements<BuildState>()
  factory GuardWidgetState.idle() = GuardWidgetStateIdle;

  factory GuardWidgetState.logout() = GuardWidgetStateLogout;

  factory GuardWidgetState.securedLogin() = GuardWidgetStateSecuredLogin;
}
