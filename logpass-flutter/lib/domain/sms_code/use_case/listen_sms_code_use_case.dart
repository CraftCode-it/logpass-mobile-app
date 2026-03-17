import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/sms_code/sms_code_repository.dart';

@Injectable()
class ListenSmsCodeUseCase {
  final SmsCodeRepository _smsCodeRepository;

  ListenSmsCodeUseCase(this._smsCodeRepository);

  Stream<String> call() => _smsCodeRepository.listenForSmsCode();
}