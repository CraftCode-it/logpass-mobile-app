import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'entry_page_state.freezed.dart';

@freezed
class EntryPageState with _$EntryPageState {
  @Implements(BuildState)
  factory EntryPageState.idle() = _EntryPageStateIdle;

  factory EntryPageState.onboarding() = _EntryPageStateOnboarding;

  factory EntryPageState.home() = _EntryPageStateHome;

  factory EntryPageState.securedLogin() = _EntryPageStateSecuredLogin;
}
