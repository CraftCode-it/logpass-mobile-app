import 'dart:async';

import 'package:injectable/injectable.dart';

@LazySingleton()
class ActionsChangedNotifier {
  final StreamController<String> _streamController = StreamController.broadcast();

  void notify(String actionId) => _streamController.sink.add(actionId);

  Stream<String> listen() => _streamController.stream;
}
