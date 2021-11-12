abstract class AppLifeCycleStore {

  Future<void> appSentToBackground();

  Future<int?> getAppBackgroundTime();

  Future<bool> wasInBackground();
}