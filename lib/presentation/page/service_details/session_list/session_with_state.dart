import 'package:logpass_me/domain/service/data/session/service_session.dart';

class SessionWithState {
  final ServiceSession session;
  final bool endingSessionInProgress;
  final bool expanded;

  SessionWithState(
    this.session,
    this.endingSessionInProgress,
    this.expanded,
  );

  SessionWithState copyWith({bool? endingSessionInProgress, bool? expanded}) {
    return SessionWithState(
      session,
      endingSessionInProgress ?? this.endingSessionInProgress,
      expanded ?? this.expanded,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionWithState &&
          runtimeType == other.runtimeType &&
          session == other.session &&
          endingSessionInProgress == other.endingSessionInProgress &&
          expanded == other.expanded;

  @override
  int get hashCode => session.hashCode ^ endingSessionInProgress.hashCode ^ expanded.hashCode;
}
