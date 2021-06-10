part of 'main_page_cubit.dart';

@freezed
class MainPageState with _$MainPageState {
  const factory MainPageState.showAction() = _MainPageStateShowAction;

  @Implements(BuildState)
  const factory MainPageState.idle() = _MainPageStateIdle;

  const factory MainPageState.error(String message) = _MainPageStateError;
}
