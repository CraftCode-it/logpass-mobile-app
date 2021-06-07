part of 'one_time_code_container_cubit.dart';

@freezed
class OneTimeCodeContainerState with _$OneTimeCodeContainerState {
  const factory OneTimeCodeContainerState.loadInProgress() = LoadInProgress;

  const factory OneTimeCodeContainerState.idle(OneTimeCode oneTimeCode, double remainingProgress) = Idle;

  const factory OneTimeCodeContainerState.error() = Error;
}
