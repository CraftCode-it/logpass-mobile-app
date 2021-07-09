part of 'authorize_page_cubit.dart';

@freezed
class AuthorizePageState with _$AuthorizePageState {
  @Implements(BuildState)
  const factory AuthorizePageState.loading() = _AuthorizePageStateLoading;

  @Implements(BuildState)
  const factory AuthorizePageState.idle(
    bool canConfirm,
    Service service,
    List<ScopeElement> scopeElements,
    List<ServiceAgreement> agreements,
    int requiredTrustLevel,
    int currentTrustLevel,
  ) = _AuthorizePageStateIdle;

  const factory AuthorizePageState.confirmed(String? redirectUri) = _AuthorizePageStateConfirmed;

  const factory AuthorizePageState.denied(String? redirectUri) = _AuthorizePageStateDenied;

  const factory AuthorizePageState.connectionError(GeneralConnectionError error) = _AuthorizePageStateConnectionError;

  const factory AuthorizePageState.biometricVerificationNeeded() = _AuthorizePageStateBiometricVerificationNeeded;
}
