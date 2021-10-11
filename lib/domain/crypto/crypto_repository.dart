abstract class CryptoRepository {
  Future<String> getVerifyKeyAsBase64();

  Future<String> getPublicKeyAsBase64();

}
