import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/country_code/country_code.dart';
import 'package:logpass_me/domain/country_code/country_code_repository.dart';
import 'package:logpass_me/domain/language/use_case/get_language_code_use_case.dart';

@Injectable()
class GetCountryCodesUseCase {
  final CountryCodeRepository _countryCodeRepository;
  final GetLanguageCodeUseCase _getLanguageCodeUseCase;

  GetCountryCodesUseCase(this._countryCodeRepository, this._getLanguageCodeUseCase);

  Future<List<CountryCode>> call() async {
    final languageCode = await _getLanguageCodeUseCase();
    return _countryCodeRepository.load(languageCode);
  }
}
