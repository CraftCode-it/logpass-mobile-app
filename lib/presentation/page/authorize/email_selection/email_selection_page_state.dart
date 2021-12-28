part of 'email_selection_page_cubit.dart';

@freezed
class EmailSelectionPageState with _$EmailSelectionPageState {
  @Implements<BuildState>()
  const factory EmailSelectionPageState.idle(
    List<Email> emails,
    Email selectedEmail,
  ) = _EmailSelectionPageStateIdle;

  @Implements<BuildState>()
  factory EmailSelectionPageState.loading() = _EmailSelectionPageStateLoading;

  @Implements<BuildState>()
  factory EmailSelectionPageState.empty() = _EmailSelectionPageStateEmpty;

  factory EmailSelectionPageState.connectionError(GeneralConnectionError error) =
      _EmailSelectionPageStateConnectionError;
}
