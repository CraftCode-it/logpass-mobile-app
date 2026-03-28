import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_type.freezed.dart';

@freezed
class ActionType with _$ActionType {
  factory ActionType.authorize() = _ActionTypeAuthorize;

  factory ActionType.refreshUserCode() = _ActionTypeRefreshUserCode;

  factory ActionType.confirm() = _ActionTypeConfirm;

  factory ActionType.updateAccount() = _ActionTypeUpdateAccount;

  /// Triggered by a WebSocket push or QR scan from a verifier requesting age/identity proof
  factory ActionType.logpassVerify() = _ActionTypeLogpassVerify;

  /// Guardian pairing request from minor (WS push to guardian)
  factory ActionType.guardianPairing() = _ActionTypeGuardianPairing;

  /// Authorization request from minor to guardian for a service action
  factory ActionType.guardianAuthRequest() = _ActionTypeGuardianAuthRequest;

  /// Result of authorization request (approved/rejected/expired) — pushed to minor
  factory ActionType.guardianAuthResult() = _ActionTypeGuardianAuthResult;
}

// TODO: refactor keys after backend's implementation
ActionType mapActionType(String key) {
  switch (key.toLowerCase()) {
    case 'authorize':
    case 'oauth2_authorize':
      return ActionType.authorize();
    case 'refresh_usercode':
      return ActionType.refreshUserCode();
    case 'confirm':
      return ActionType.confirm();
    case 'updateaccount':
      return ActionType.updateAccount();
    case 'logpass_verify':
      return ActionType.logpassVerify();
    case 'guardian_pairing':
      return ActionType.guardianPairing();
    case 'guardian_auth_request':
      return ActionType.guardianAuthRequest();
    case 'guardian_auth_result':
      return ActionType.guardianAuthResult();
    default:
      throw Exception('Unsupported action type');
  }
}