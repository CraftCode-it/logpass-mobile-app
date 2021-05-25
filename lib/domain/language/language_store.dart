abstract class LanguageStore {
  Future<String> getLanguageCode();

  Future<void> setLanguageCode(String languageCode);
}
