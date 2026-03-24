import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/incoming_actions/dtos/incoming_action_dto.dart';
import 'package:logpass_me/domain/incoming_actions/action_type.dart';
import 'package:logpass_me/data/incoming_actions/incoming_actions_validator.dart';
import 'package:logpass_me/data/incoming_actions/mappers/incoming_push_action_dto_to_incoming_action_mapper.dart';
import 'package:logpass_me/data/incoming_actions/mappers/web_socket_action_dto_to_incoming_action_mapper.dart';
import 'package:logpass_me/data/push_notifications/push_notifications_manager.dart';
import 'package:logpass_me/data/web_socket/web_socket_manager.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_with_splitted_actions_repository.dart';

@Singleton(as: IncomingWithSplittedActionsRepository)
class IncomingActionsRepositoryImpl implements IncomingWithSplittedActionsRepository {
  final WebSocketManager _webSocketManager;
  final PushNotificationsManager _pushNotificationsManager;
  final StreamController<IncomingAction> _incomingUsersActionsBroadcast = StreamController.broadcast();
  final StreamController<IncomingAction> _incomingRefreshCodeActionsBroadcast = StreamController.broadcast();
  final IncomingActionsValidator _incomingActionsValidator;
  final WebSocketActionDTOToIncomingActionMapper _webSocketActionDTOToIncomingActionMapper;
  final IncomingPushActionDTOToIncomingActionMapper _pushActionDTOToIncomingActionMapper;

  StreamSubscription? _messagesStreamSubscription;
  StreamSubscription? _webSocketStreamSubscription;

  IncomingActionsRepositoryImpl(
    this._webSocketManager,
    this._pushNotificationsManager,
    this._webSocketActionDTOToIncomingActionMapper,
    this._incomingActionsValidator,
    this._pushActionDTOToIncomingActionMapper,
  );

  @override
  Stream<IncomingAction> listenForIncomingActions() {
    _setupForegroundMessagesListener();
    _setupWebSocketChannelListener();
    return _incomingUsersActionsBroadcast.stream;
  }

  @override
  Stream<IncomingAction> listenForIncomingRefreshCodeActions() =>
      _incomingRefreshCodeActionsBroadcast.stream;

  IncomingAction _mapIncomingActionDto(Map<String, dynamic> jsonMap) {
    final actionDto = IncomingActionDTO.fromJson(jsonMap);
    return _webSocketActionDTOToIncomingActionMapper(actionDto);
  }

  void _dispatchAction(IncomingAction action) {
    if (_incomingActionsValidator.canInvoke(action)) {
      action.actionType.maybeMap(
        refreshUserCode: (_) => _incomingRefreshCodeActionsBroadcast.add(action),
        orElse: () => _incomingUsersActionsBroadcast.add(action)
      );
    }
  }

  void _setupWebSocketChannelListener() {
    if (_webSocketStreamSubscription != null) return;

    _webSocketStreamSubscription = _webSocketManager.listenForChannel().listen((event) {
      final jsonMap = json.decode(event as String) as Map<String, dynamic>;
      // Handle raw logpass_verify push messages from auth-service
      if (jsonMap['type'] == 'logpass_verify') {
        final requestId = jsonMap['request_id'] as String?;
        final action = IncomingAction.create(
          ActionType.logpassVerify(),
          requestId,
          null,
          {
            'request_id': requestId ?? '',
            'verifier': (jsonMap['verifier'] as String?) ?? '',
            'request_type': (jsonMap['request_type'] as String?) ?? 'age_18',
            'min_age': (jsonMap['min_age'] ?? 18).toString(),
          },
        );
        _dispatchAction(action);
        return;
      }
      final incomingAction = _mapIncomingActionDto(jsonMap);
      _dispatchAction(incomingAction);
    });
  }

  void _setupForegroundMessagesListener() {
    if (_messagesStreamSubscription != null) return;

    _messagesStreamSubscription = _pushNotificationsManager.listenForForegroundMessages().listen((message) {
      final action = _pushActionDTOToIncomingActionMapper(message);

      if (action == null) return;

      _dispatchAction(action);
    });
  }

  @override
  Future<void> clear() async {
    await _messagesStreamSubscription?.cancel();
    await _webSocketStreamSubscription?.cancel();
    _messagesStreamSubscription = null;
    _webSocketStreamSubscription = null;
  }
}
