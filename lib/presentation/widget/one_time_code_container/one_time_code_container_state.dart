part of 'one_time_code_container_cubit.dart';

@freezed
class OneTimeCodeContainerState with _$OneTimeCodeContainerState {
  @Implements(BuildState)
  const factory OneTimeCodeContainerState.loadInProgress() = LoadInProgress;

  @Implements(BuildState)
  const factory OneTimeCodeContainerState.idle(OneTimeCode oneTimeCode) = Idle;

  @Implements(BuildState)
  const factory OneTimeCodeContainerState.internetConnection(bool hasInternetConnection) = InternetConnection;

  @Implements(BuildState)
  const factory OneTimeCodeContainerState.error() = Error;

  const factory OneTimeCodeContainerState.connectionError(GeneralConnectionError error) = ConnectionError;
}
