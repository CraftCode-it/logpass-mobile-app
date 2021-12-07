import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/sms_code/sms_code_manager.dart';
import 'package:logpass_me/data/sms_code/sms_code_mapper.dart';
import 'package:logpass_me/domain/sms_code/sms_code_repository.dart';

@LazySingleton(as: SmsCodeRepository)
class SmsCodeRepositoryImpl implements SmsCodeRepository {
  final SmsCodeManager _otpCodeManager;
  final SmsCodeMapper _otpCodeMapper;

  SmsCodeRepositoryImpl(this._otpCodeManager, this._otpCodeMapper);

  @override
  Stream<String> listenForSmsCode() {
    _otpCodeManager.init();

    return _otpCodeManager.listenSmsCode()
        .map((event) => _otpCodeMapper(event))
        .where((event) => event != null)
        .map((event) => event!);
  }

  @override
  Future<void> dispose() async {
    await _otpCodeManager.dispose();
  }
}