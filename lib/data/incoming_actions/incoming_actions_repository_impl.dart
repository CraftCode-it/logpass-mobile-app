import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/incoming_actions/dtos/incoming_action_dto.dart';
import 'package:logpass_me/data/push_notifications/push_notifications_manager.dart';
import 'package:logpass_me/data/web_socket/web_socket_manager.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_actions_repository.dart';
import 'package:logpass_me/domain/common/clearable.dart';

@Singleton(as: IncomingActionsRepository)
class IncomingActionsRepositoryImpl implements IncomingActionsRepository, Clearable {
  final WebSocketManager _webSocketManager;
  final PushNotificationsManager _pushNotificationsManager;
  final StreamController<IncomingAction> _incomingActionsBroadcast = StreamController.broadcast();
  final List<IncomingAction> _actionsInCurrentSession = [];

  StreamSubscription? _messagesStreamSubscription;
  StreamSubscription? _webSocketStreamSubscription;

  IncomingActionsRepositoryImpl(this._webSocketManager, this._pushNotificationsManager);

  @override
  Stream<IncomingAction> listenForIncomingActions() {
    _setupForegroundMessagesListener();
    _setupWebSocketChannelListener();
    return _incomingActionsBroadcast.stream;
  }

  IncomingAction _mapIncomingActionDto(Map<String, dynamic> jsonMap) {
    final actionDto = IncomingActionDTO.fromJson(jsonMap);
    return IncomingAction(actionDto.link);
  }

  void _dispatchAction(IncomingAction action) {
    if (!_actionsInCurrentSession.contains(action)) {
      _actionsInCurrentSession.add(action);
      _incomingActionsBroadcast.add(action);
    }
  }

  void _setupWebSocketChannelListener() {
    if (_webSocketStreamSubscription != null) return;

    _webSocketStreamSubscription = _webSocketManager.listenForChannel().listen((event) {
      final jsonMap = json.decode(event as String) as Map<String, dynamic>;
      final incomingAction = _mapIncomingActionDto(jsonMap);
      _dispatchAction(incomingAction);
    });
  }

  void _setupForegroundMessagesListener() {
    if (_messagesStreamSubscription != null) return;

    _messagesStreamSubscription = _pushNotificationsManager.listenForForegroundMessages().listen((message) {
      final incomingAction = _mapIncomingActionDto(message.data);
      _dispatchAction(incomingAction);
    });
  }

  @override
  void clear() {
    _messagesStreamSubscription?.cancel();
    _webSocketStreamSubscription?.cancel();
  }
}
