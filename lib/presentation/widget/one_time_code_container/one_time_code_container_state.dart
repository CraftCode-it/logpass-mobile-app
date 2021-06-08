part of 'one_time_code_container_cubit.dart';

@freezed
class OneTimeCodeContainerState with _$OneTimeCodeContainerState {
  @Implements(BuildState)
  const factory OneTimeCodeContainerState.loadInProgress() = LoadInProgress;

  @Implements(BuildState)
  const factory OneTimeCodeContainerState.idle(OneTimeCode oneTimeCode, double remainingProgress) = Idle;

  @Implements(BuildState)
  const factory OneTimeCodeContainerState.error() = Error;
}
