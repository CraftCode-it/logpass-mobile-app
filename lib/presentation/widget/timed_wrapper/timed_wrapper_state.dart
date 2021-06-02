import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'timed_wrapper_state.freezed.dart';

@freezed
class TimedWrapperState with _$TimedWrapperState {
  @Implements(BuildState)
  factory TimedWrapperState.loading() = _TimedWrapperStateLoading;

  @Implements(BuildState)
  factory TimedWrapperState.ongoing() = _TimedWrapperStateOngoing;

  @Implements(BuildState)
  factory TimedWrapperState.passed() = _TimedWrapperStatePassed;
}
