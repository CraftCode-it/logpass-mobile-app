part of 'data_personal_form_page_cubit.dart';

@freezed
class DataPersonalFormPageState with _$DataPersonalFormPageState {
  @Implements(BuildState)
  const factory DataPersonalFormPageState.loading() = _DataPersonalFormPageStateLoading;

  @Implements(BuildState)
  const factory DataPersonalFormPageState.idle(
    bool canSave,
    bool areSomeFieldsFilled,
  ) = _DataPersonalFormPageStateIdle;

  factory DataPersonalFormPageState.connectionError(GeneralConnectionError error) =
      _DataPersonalFormPageStateConnectionError;

  factory DataPersonalFormPageState.savedSuccessful() = _DataPersonalFormPageStateSavedSuccessful;

  factory DataPersonalFormPageState.duplicatedEntry() = _DataPersonalFormPageStateDuplicatedEntry;
}
