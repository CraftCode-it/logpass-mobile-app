part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.loadInProgress() = LoadInProgress;

  // TODO: refactor in accordance to backend model
  const factory HomeState.idle(List<String> pendingActions) = Idle;

  const factory HomeState.error(String message) = Error;
}
