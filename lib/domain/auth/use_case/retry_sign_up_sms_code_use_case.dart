import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/auth/auth_repository.dart';
import 'package:logpass_me/domain/auth/sign_up/sign_up_verification.dart';

@Injectable()
class RetrySignUpSmsCodeUseCase {
  final AuthRepository _authRepository;

  RetrySignUpSmsCodeUseCase(this._authRepository);

  Future<SignUpVerification> call(String attemptId) async =>
      await _authRepository.retrySignUp(attemptId);
}