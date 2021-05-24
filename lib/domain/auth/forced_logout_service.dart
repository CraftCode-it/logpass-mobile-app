import 'dart:async';

import 'package:injectable/injectable.dart';

@LazySingleton()
class ForcedLogoutService {
  final StreamController _logoutEventStreamController = StreamController.broadcast();

  Stream<void> get logoutEventStream => _logoutEventStreamController.stream;

  Future<void> logout() async {
    //TODO logout logic
    _logoutEventStreamController.sink.add(Object());
  }
}
