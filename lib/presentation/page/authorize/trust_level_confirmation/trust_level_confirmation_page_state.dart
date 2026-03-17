part of 'trust_level_confirmation_page_cubit.dart';

@freezed
class TrustLevelConfirmationPageState with _$TrustLevelConfirmationPageState {
  @Implements<BuildState>()
  const factory TrustLevelConfirmationPageState.idle(
    int currentTrustLevel,
    int requiredTrustLevel,
    List<Device> availableDevices,
    List<Device> unavailableDevices,
  ) = _TrustLevelConfirmationPageStateIdle;

  @Implements<BuildState>()
  const factory TrustLevelConfirmationPageState.loading() = _TrustLevelConfirmationPageStateLoading;

  const factory TrustLevelConfirmationPageState.connectionError(GeneralConnectionError error) =
      _TrustLevelConfirmationPageStateConnectionError;

  const factory TrustLevelConfirmationPageState.error() = _TrustLevelConfirmationPageStateError;
}
