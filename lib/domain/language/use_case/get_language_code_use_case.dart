import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/language/language_store.dart';

@injectable
class GetLanguageCodeUseCase {
  final LanguageStore _languageStore;

  GetLanguageCodeUseCase(this._languageStore);

  Future<String> call() => _languageStore.getLanguageCode();
}