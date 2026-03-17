import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/domain/event_log/event_log.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'event_log_page_state.freezed.dart';

@freezed
class EventLogPageState with _$EventLogPageState {
  @Implements<BuildState>()
  factory EventLogPageState.loading() = _EventLogPageStateLoading;

  @Implements<BuildState>()
  factory EventLogPageState.idle(List<EventLog> events, bool loadingMore,) = _EventLogPageStateIdle;

  @Implements<BuildState>()
  factory EventLogPageState.empty() = _EventLogPageStateEmpty;

  @Implements<BuildState>()
  factory EventLogPageState.error() = _EventLogPageStateError;

  factory EventLogPageState.connectionError(GeneralConnectionError error) = _EventLogPageStateConnectionError;
}
