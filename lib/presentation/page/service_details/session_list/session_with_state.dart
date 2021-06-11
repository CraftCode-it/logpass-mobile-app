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
}
