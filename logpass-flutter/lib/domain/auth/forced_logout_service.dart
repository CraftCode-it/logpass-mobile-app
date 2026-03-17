import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/auth/logout_service.dart';
import 'package:logpass_me/domain/common/clearable.dart';

@LazySingleton(as: LogoutService)
class ForcedLogoutService implements LogoutService {
  final List<Clearable> _clearables;

  final StreamController _logoutEventStreamController = StreamController.broadcast();

  ForcedLogoutService(this._clearables);

  @override
  Stream<void> get logoutEventStream => _logoutEventStreamController.stream;

  @override
  Future<void> logout() async {
    await _clearAll();

    _logoutEventStreamController.sink.add(Object());
  }

  @override
  Future<void> logoutWithoutListenableCallback() => _clearAll();

  Future<void> _clearAll() async {
    for (final clearable in _clearables) {
      try {
        await clearable.clear();
      } catch (e, s) {
        Fimber.e('Failed to clear ${clearable.runtimeType}', ex: e, stacktrace: s);
      }
    }
  }
}
