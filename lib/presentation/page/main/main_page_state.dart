part of 'main_page_cubit.dart';

@freezed
class MainPageState with _$MainPageState {
  @Implements<BuildState>()
  const factory MainPageState.idle() = _MainPageStateIdle;

  const factory MainPageState.openAction(IncomingAction action) = _MainPageStateOpenAction;

  const factory MainPageState.error(String message) = _MainPageStateError;
}
