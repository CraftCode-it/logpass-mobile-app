import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'messenger_state.freezed.dart';

@freezed
class MessengerState with _$MessengerState {
  @Implements(BuildState)
  factory MessengerState.idle() = _MessengerStateIdle;

  @Implements(BuildState)
  factory MessengerState.action(IncomingAction action) = _MessengerStateAction;

  @Implements(BuildState)
  factory MessengerState.info(String message, String? action, Function()? onAction) = _MessengerStateInfo;

  @Implements(BuildState)
  factory MessengerState.error(String message) = _MessengerStateError;
}
