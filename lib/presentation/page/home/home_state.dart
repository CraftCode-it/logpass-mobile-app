part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  @Implements(BuildState)
  const factory HomeState.loadInProgress() = _HomeStateLoadInProgress;

  // TODO: refactor in accordance to backend model
  @Implements(BuildState)
  const factory HomeState.idle(List<IncomingAction> pendingActions) = _HomeStateIdle;

  const factory HomeState.codeCopied() = _HomeStateCodeCopied;

  const factory HomeState.error(String message) = _HomeStateError;
}
