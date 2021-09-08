import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';

@LazySingleton()
class ActionsChangedNotifier {
  final StreamController<IncomingAction> _streamController = StreamController.broadcast();

  void notify(IncomingAction incomingAction) => _streamController.sink.add(incomingAction);

  Stream<IncomingAction> listen() => _streamController.stream;
}
