abstract class LogoutService {
  Stream<void> get logoutEventStream;
  Future<void> logout();
}
