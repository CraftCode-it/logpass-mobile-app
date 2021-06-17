import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_with_state.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'session_list_view_state.freezed.dart';

@freezed
class SessionListViewState with _$SessionListViewState {
  @Implements(BuildState)
  factory SessionListViewState.loading() = _SessionListViewStateLoading;

  @Implements(BuildState)
  factory SessionListViewState.idle(
    List<SessionWithState> sessions,
    bool loadingMore,
    bool activeSessions,
  ) = SessionListViewStateIdle;

  @Implements(BuildState)
  factory SessionListViewState.empty(bool activeSessions) = _SessionListViewStateEmpty;

  factory SessionListViewState.endedSession() = _SessionListViewStateEndedSession;

  factory SessionListViewState.connectionError(GeneralConnectionError error) = _SessionListViewStateConnectionError;
}
