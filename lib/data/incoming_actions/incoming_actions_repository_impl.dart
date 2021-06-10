import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/incoming_actions/dtos/incoming_action_dto.dart';
import 'package:logpass_me/data/web_socket/web_socket_manager.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_actions_repository.dart';

@Singleton(as: IncomingActionsRepository)
class IncomingActionsRepositoryImpl implements IncomingActionsRepository {
  final WebSocketManager _webSocketManager;

  IncomingActionsRepositoryImpl(this._webSocketManager);

  @override
  Stream<IncomingAction> listenForIncomingActions() => _webSocketManager.listenForChannel().map(_mapIncomingActionDto);

  IncomingAction _mapIncomingActionDto(dynamic event) {
    final jsonMap = json.decode(event as String) as Map<String, dynamic>;
    final actionDto = IncomingActionDTO.fromJson(jsonMap);
    return IncomingAction(actionDto.link);
  }
}
