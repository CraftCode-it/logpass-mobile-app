part of 'main_page_cubit.dart';

@freezed
class MainPageState with _$MainPageState {
  @Implements(BuildState)
  const factory MainPageState.loading() = _MainPageStateLoading;

  @Implements(BuildState)
  const factory MainPageState.idle() = _MainPageStateIdle;

  const factory MainPageState.error() = _MainPageStateError;
}
