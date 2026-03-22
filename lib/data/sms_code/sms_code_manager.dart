import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton()
class SmsCodeManager {
  final BehaviorSubject<String?> _oneTimeCodeSubject = BehaviorSubject<String?>();

  Future<void> init() async {
    // sms_user_consent removed (incompatible Kotlin version)
  }

  Future<void> dispose() async {}

  Stream<String?> listenSmsCode() =>
      _oneTimeCodeSubject.stream;
}
