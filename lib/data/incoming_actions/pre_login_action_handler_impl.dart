import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_actions_from_link_repository.dart';
import 'package:logpass_me/domain/incoming_actions/pre_login_action_handler.dart';
import 'package:logpass_me/domain/incoming_actions/queued_incoming_action_repository.dart';

@LazySingleton(as: PreLoginActionHandler)
class PreLoginActionHandlerImpl implements PreLoginActionHandler {
  final IncomingActionsFromLinkRepository _incomingActionsFromLinkRepository;
  final QueuedIncomingActionRepository _queuedIncomingActionRepository;

  StreamSubscription? _subscription;

  PreLoginActionHandlerImpl(
    this._incomingActionsFromLinkRepository,
    this._queuedIncomingActionRepository,
  );

  @override
  Future<void> enable() async {
    await _subscription?.cancel();
    _subscription = _incomingActionsFromLinkRepository.listenForIncomingActions().listen((event) {
      _queuedIncomingActionRepository.queueIncomingAction(event);
    });
  }

  @override
  Future<void> disable() async {
    await _subscription?.cancel();
  }
}
