abstract class SmsCodeRepository {
  Stream<String> listenForSmsCode();

  Future<void> dispose();
}