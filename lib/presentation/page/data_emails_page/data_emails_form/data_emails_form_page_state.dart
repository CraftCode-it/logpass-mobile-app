part of 'data_emails_form_page_cubit.dart';

@freezed
class DataEmailsFormPageState with _$DataEmailsFormPageState {
  @Implements(BuildState)
  const factory DataEmailsFormPageState.loading() = _DataEmailsFormPageStateLoading;

  @Implements(BuildState)
  const factory DataEmailsFormPageState.idle(
    bool canSave,
    bool isFieldFilled,
  ) = _DataEmailsFormPageStateIdle;

  factory DataEmailsFormPageState.connectionError(GeneralConnectionError error) =
      _DataEmailsFormPageStateConnectionError;

  factory DataEmailsFormPageState.savedSuccessful() = _DataEmailsFormPageStateSavedSuccessful;
  factory DataEmailsFormPageState.duplicatedEntry() = _DataEmailsFormPageStateDuplicatedEntry;
}
