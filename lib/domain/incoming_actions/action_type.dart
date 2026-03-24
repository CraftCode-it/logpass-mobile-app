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
    default:
      throw Exception('Unsupported action type');
  }
}