abstract class AppStore {
  Future<bool> isFirstRun();

  Future<void> markFirstRun();
}
