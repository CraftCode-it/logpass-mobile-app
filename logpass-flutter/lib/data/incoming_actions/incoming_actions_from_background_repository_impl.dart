import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/incoming_actions/incoming_actions_validator.dart';
import 'package:logpass_me/data/incoming_actions/mappers/incoming_push_action_dto_to_incoming_action_mapper.dart';
import 'package:logpass_me/data/push_notifications/push_notifications_manager.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_actions_from_background_repository.dart';

@LazySingleton(as: IncomingActionsFromBackgroundRepository)
class IncomingActionsFromBackgroundRepositoryImpl implements IncomingActionsFromBackgroundRepository {
  final StreamController<IncomingAction> _incomingActionsBroadcast = StreamController.broadcast();
  StreamSubscription? _messagesStreamSubscription;

  final PushNotificationsManager _pushNotificationsManager;
  final IncomingActionsValidator _incomingActionsValidator;
  final IncomingPushActionDTOToIncomingActionMapper _pushActionDTOToIncomingActionMapper;

  IncomingActionsFromBackgroundRepositoryImpl(
    this._pushNotificationsManager,
    this._incomingActionsValidator,
    this._pushActionDTOToIncomingActionMapper,
  );

  @override
  Stream<IncomingAction> listenForIncomingActions() {
    _initBackgroundStream();
    return _incomingActionsBroadcast.stream;
  }

  void _initBackgroundStream() {
    if (_messagesStreamSubscription != null) return;

    _messagesStreamSubscription = _pushNotificationsManager
        .listenForBackgroundMessages()
        .map<IncomingAction?>(_pushActionDTOToIncomingActionMapper)
        .where((event) => event != null)
        .map((e) => e!) //<3
        .map((event) => event).listen(_incomingActionsBroadcast.add);
  }

  @override
  Future<void> clear() async {
    await _messagesStreamSubscription?.cancel();
    _messagesStreamSubscription = null;
  }
}
