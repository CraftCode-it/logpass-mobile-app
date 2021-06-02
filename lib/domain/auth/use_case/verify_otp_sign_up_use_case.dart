import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/auth/auth_repository.dart';
import 'package:logpass_me/domain/auth/auth_store.dart';

@Injectable()
class VerifyOTPSignUpUseCase {
  final AuthRepository _authRepository;
  final AuthStore _authStore;

  VerifyOTPSignUpUseCase(this._authRepository, this._authStore);

  Future<void> call(String url, String otpCode) async {
    final tokens = await _authRepository.verifyOTPSignUp(url, otpCode);
    await _authStore.saveUserTokens(tokens);
  }
}
