import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sms_user_consent/sms_user_consent.dart';

@LazySingleton()
class SmsCodeManager {
  late SmsUserConsent? _smsUserConsent;
  final BehaviorSubject<String?> _oneTimeCodeSubject = BehaviorSubject<String?>();

  Future<void> init() async {
    _smsUserConsent = SmsUserConsent(
      smsListener: () => _oneTimeCodeSubject.add(_smsUserConsent?.receivedSms),
    );

    _smsUserConsent?.requestSms();
  }

  Future<void> dispose() async {
    _smsUserConsent?.dispose();
  }

  Stream<String?> listenSmsCode() =>
      _oneTimeCodeSubject.stream;
}