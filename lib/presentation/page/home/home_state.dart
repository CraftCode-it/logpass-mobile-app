part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.loadInProgress() = LoadInProgress;

  const factory HomeState.idle(OneTimeCode oneTimeCode) = Idle;

  const factory HomeState.error(String message) = Error;
}
