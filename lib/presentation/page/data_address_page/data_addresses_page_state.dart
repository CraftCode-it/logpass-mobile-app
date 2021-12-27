part of 'data_addresses_page_cubit.dart';

@freezed
class DataAddressesPageState with _$DataAddressesPageState {
  @Implements<BuildState>()
  factory DataAddressesPageState.idle(List<Address> addressList) = _DataAddressesPageStateIdle;

  @Implements<BuildState>()
  factory DataAddressesPageState.loading() = _DataAddressesPageStateLoading;

  @Implements<BuildState>()
  factory DataAddressesPageState.empty() = _DataAddressesPageStateEmpty;

  factory DataAddressesPageState.connectionError(GeneralConnectionError error) = _DataAddressesPageStateConnectionError;

  factory DataAddressesPageState.removalConfirmationNeeded(Address address) =
      _DataAddressesPageStateRemovalConfirmationNeeded;

  factory DataAddressesPageState.addressRemoved() = _DataAddressesPageStateAddressRemoved;
}
