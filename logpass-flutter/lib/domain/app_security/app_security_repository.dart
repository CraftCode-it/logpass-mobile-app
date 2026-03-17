abstract class AppSecurityRepository {
  Future<bool> supportsBiometric();

  Future<bool> authenticate();
}
