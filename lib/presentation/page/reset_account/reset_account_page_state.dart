part of 'reset_account_page_cubit.dart';

@freezed
class ResetAccountPageState with _$ResetAccountPageState {
  @Implements(BuildState)
  factory ResetAccountPageState.idle() = _ResetAccountPageStateIdle;

  @Implements(BuildState)
  factory ResetAccountPageState.processing() = _ResetAccountPageStateProcessing;

  factory ResetAccountPageState.connectionError(GeneralConnectionError error) = _ResetAccountPageStateConnectionError;

  factory ResetAccountPageState.error() = _ResetAccountPageStateError;

  factory ResetAccountPageState.accountResetSuccessful() = _ResetAccountPageStateAccountResetSuccessful;
}
