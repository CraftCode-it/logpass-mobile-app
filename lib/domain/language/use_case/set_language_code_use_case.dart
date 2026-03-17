import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/language/language_store.dart';

@Injectable()
class SetLanguageCodeUseCase {
  final LanguageStore _languageStore;

  SetLanguageCodeUseCase(this._languageStore);

  Future<void> call(String languageCode) =>
      _languageStore.setLanguageCode(languageCode);
}
