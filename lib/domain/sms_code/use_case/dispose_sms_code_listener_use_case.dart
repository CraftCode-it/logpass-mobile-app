import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/sms_code/sms_code_repository.dart';

@Injectable()
class DisposeSmsCodeListenerUseCase  {
  final SmsCodeRepository _smsCodeRepository;

  DisposeSmsCodeListenerUseCase(this._smsCodeRepository);

  Future<void> call() => _smsCodeRepository.dispose();
}