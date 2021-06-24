part of 'address_selection_page_cubit.dart';

@freezed
class AddressSelectionPageState with _$AddressSelectionPageState {
  @Implements(BuildState)
  const factory AddressSelectionPageState.idle(
    List<Address> addresses,
    Address selectedAddress,
  ) = _AddressSelectionPageStateIdle;

  @Implements(BuildState)
  factory AddressSelectionPageState.loading() = _AddressSelectionPageStateLoading;

  @Implements(BuildState)
  factory AddressSelectionPageState.empty() = _AddressSelectionPageStateEmpty;

  factory AddressSelectionPageState.connectionError(GeneralConnectionError error) =
      _AddressSelectionPageStateConnectionError;
}
