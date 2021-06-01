import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/crypto/crypto_repository.dart';

@LazySingleton(as: CryptoRepository)
class CryptoRepositoryMock implements CryptoRepository {
  @override
  Future<String> getPublicKeyAsBase64() async {
    return 'CxDFV71AL2KbSLAiBtuBR6mJWhCm1p4/Qi5yqG7eSDU=';
  }

  @override
  Future<String> getVerifyKeyAsBase64() async {
    return 'Imr4QzM4mAAEfwhzUjTp98j0AenKIpJhXjY3GP/Nr0M=';
  }
}
