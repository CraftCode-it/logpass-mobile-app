import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_type.freezed.dart';

@freezed
class ActionType with _$ActionType {
  factory ActionType.authorize() = _ActionTypeAuthorize;

  factory ActionType.confirm() = _ActionTypeConfirm;

  factory ActionType.updateAccount() = _ActionTypeUpdateAccount;
}
