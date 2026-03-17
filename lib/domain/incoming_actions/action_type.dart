import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_type.freezed.dart';

@freezed
class ActionType with _$ActionType {
  factory ActionType.authorize() = _ActionTypeAuthorize;

  factory ActionType.refreshUserCode() = _ActionTypeRefreshUserCode;

  factory ActionType.confirm() = _ActionTypeConfirm;

  factory ActionType.updateAccount() = _ActionTypeUpdateAccount;
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
    default:
      throw Exception('Unsupported action type');
  }
}