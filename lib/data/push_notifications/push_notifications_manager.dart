import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/push_notifications/api/dto/push_notification_message_dto.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton()
class PushNotificationsManager {
  final FirebaseMessaging _firebaseMessaging;

  PushNotificationsManager(this._firebaseMessaging);

  Future init() async {
    await _grantPermissions();
  }

  Future<PushNotificationMessageDTO?> handleOpeningMessage() async {
    final message = await _firebaseMessaging.getInitialMessage();
    if (message == null) return null;

    return _decodeMessage(message);
  }

  Stream<PushNotificationMessageDTO> listenForForegroundMessages() => Rx.merge(
        [
          FirebaseMessaging.onMessage,
          FirebaseMessaging.onMessageOpenedApp,
        ],
      ).map(_decodeMessage);

  Future<String?> getRegistrationRefreshToken() => _firebaseMessaging.getToken();

  Stream<String> listenForRefreshToken() => _firebaseMessaging.onTokenRefresh;

  PushNotificationMessageDTO _decodeMessage(RemoteMessage message) {
    final decoded = message.data.containsKey('body') ? jsonDecode(message.data['body'] as String) : null;

    final data = {
      'action': message.data['action'] as String,
      if (decoded != null) 'body': decoded,
    };

    return PushNotificationMessageDTO.fromJson(data);
  }

  Future<void> _grantPermissions() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
}
