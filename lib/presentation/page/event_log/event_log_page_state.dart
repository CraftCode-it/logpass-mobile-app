import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/domain/event_log/past_event.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'event_log_page_state.freezed.dart';

@freezed
class EventLogPageState with _$EventLogPageState {
  @Implements(BuildState)
  factory EventLogPageState.loading() = _EventLogPageStateLoading;

  @Implements(BuildState)
  factory EventLogPageState.idle(List<PastEvent> events) = _EventLogPageStateIdle;

  @Implements(BuildState)
  factory EventLogPageState.error() = _EventLogPageStateError;

  factory EventLogPageState.connectionError(GeneralConnectionError error) = _EventLogPageStateConnectionError;
}
