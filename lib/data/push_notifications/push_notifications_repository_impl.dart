import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/push_notifications/push_notifications_manager.dart';
import 'package:logpass_me/domain/common/clearable.dart';
import 'package:logpass_me/domain/push_notifications/push_notifications_repository.dart';

@Singleton(as: PushNotificationsRepository)
class PushNotificationsRepositoryImpl implements PushNotificationsRepository, Clearable {
  final PushNotificationsManager _pushNotificationsManager;

  StreamSubscription? _refreshTokenSubscription;

  PushNotificationsRepositoryImpl(this._pushNotificationsManager);

  @override
  Future<void> initNotificationsServices() async {
    await _pushNotificationsManager.init();

    final token = await _pushNotificationsManager.getRegistrationRefreshToken();
    if (token != null) await _saveDeviceTokenToStore(token);

    _refreshTokenSubscription = _pushNotificationsManager.listenForRefreshToken().listen(_saveDeviceTokenToStore);
    await _handleOpeningMessage();
  }

  Future _handleOpeningMessage() async {
    final message = await _pushNotificationsManager.handleOpeningMessage();

    if (message != null) {
      // TODO: handle opening message
    }
  }

  Future<void> _saveDeviceTokenToStore(String token) async {
    // TODO: Add saving device token to the store (API)
  }

  @override
  void clear() {
    _refreshTokenSubscription?.cancel();
  }
}
