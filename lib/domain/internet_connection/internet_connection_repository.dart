abstract class InternetConnectionRepository {
  Stream<bool> listenInternetConnection();

  Future<bool> hasInternetConnection();

  Future<void> dispose();
}