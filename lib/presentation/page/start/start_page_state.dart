import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'start_page_state.freezed.dart';

@freezed
class StartPageState with _$StartPageState {
  @Implements(BuildState)
  factory StartPageState.initial() = _StartPageStateInitial;

  @Implements(BuildState)
  factory StartPageState.idle(String phoneNumber, bool isValid) = _StartPageStateIdle;

  @Implements(BuildState)
  factory StartPageState.processing(String phoneNumber) = _StartPageStateProcessing;

  factory StartPageState.error() = _StartPageStateError;
}
