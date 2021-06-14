import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class PushNotificationsManager {
  final FirebaseMessaging _firebaseMessaging;

  PushNotificationsManager(this._firebaseMessaging);

  Future init() async {
    await _grantPermissions();
  }

  Stream<RemoteMessage> listenForForegroundMessages() => FirebaseMessaging.onMessage;

  Stream<String> listenForRefreshToken() => _firebaseMessaging.onTokenRefresh;

  Future<RemoteMessage?> handleOpeningMessage() => _firebaseMessaging.getInitialMessage();

  Future<String?> getRegistrationRefreshToken() => _firebaseMessaging.getToken();

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
