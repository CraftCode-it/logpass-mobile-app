import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/auth/auth_repository.dart';
import 'package:logpass_me/domain/auth/sign_up/sign_up_verification.dart';
import 'package:logpass_me/domain/auth/verification_method.dart';
import 'package:logpass_me/domain/crypto/crypto_repository.dart';

@Injectable()
class SignUpUsingOTPCodeUseCase {
  final AuthRepository _authRepository;
  final CryptoRepository _cryptoRepository;

  SignUpUsingOTPCodeUseCase(
    this._authRepository,
    this._cryptoRepository,
  );

  Future<SignUpVerification> call(String phoneNumber) async {
    final verifyKey = await _cryptoRepository.getVerifyKeyAsBase64();
    final publicKey = await _cryptoRepository.getPublicKeyAsBase64();

    final result = await _authRepository.signUp(phoneNumber, verifyKey, publicKey);

    if (result.verificationMethod == VerificationMethod.otpCode) return result;

    // TODO handle signature verification flow

    throw UnimplementedError();
  }
}
