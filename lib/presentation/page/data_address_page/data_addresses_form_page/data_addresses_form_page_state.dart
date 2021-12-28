part of 'data_addresses_form_page_cubit.dart';

@freezed
class DataAddressesFormPageState with _$DataAddressesFormPageState {
  @Implements<BuildState>()
  const factory DataAddressesFormPageState.loading() = _DataAddressesFormPageStateLoading;

  @Implements<BuildState>()
  const factory DataAddressesFormPageState.idle(
    bool canSave,
    bool areSomeFieldsFilled,
  ) = _DataAddressesFormPageStateIdle;

  factory DataAddressesFormPageState.connectionError(GeneralConnectionError error) =
      _DataAddressesFormPageStateConnectionError;

  factory DataAddressesFormPageState.savedSuccessful() = _DataAddressesFormPageStateSavedSuccessful;

  factory DataAddressesFormPageState.duplicatedEntry() = _DataAddressesFormPageStateDuplicatedEntry;
}
