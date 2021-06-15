part of 'authorize_page_cubit.dart';

@freezed
class AuthorizePageState with _$AuthorizePageState {
  @Implements(BuildState)
  const factory AuthorizePageState.loading() = _AuthorizePageStateLoading;

  @Implements(BuildState)
  const factory AuthorizePageState.idle(bool canProceed) = _AuthorizePageStateIdle;

  const factory AuthorizePageState.success() = _AuthorizePageStateSuccess;

  const factory AuthorizePageState.connectionError(GeneralConnectionError error) = _AuthorizePageStateConnectionError;
}
