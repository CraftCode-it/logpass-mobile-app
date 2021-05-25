import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/language/language_code.dart';
import 'package:logpass_me/domain/language/language_store.dart';

@Singleton(as: LanguageStore)
class LanguageRuntimeStore implements LanguageStore {
  String? _code;

  @override
  Future<String> getLanguageCode() async {
    final code = _code;

    if (code == null) {
      final fallbackCode = availableLocales[fallbackLanguageCode]?.languageCode;

      if (fallbackCode == null) {
        throw Exception('Fallback language code is not available');
      }

      return fallbackCode;
    }

    return code;
  }

  @override
  Future<void> setLanguageCode(String languageCode) async {
    _code = languageCode;
  }
}
