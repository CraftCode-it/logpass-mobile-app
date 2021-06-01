import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/country_code/country_code.dart';
import 'package:logpass_me/domain/country_code/country_code_repository.dart';

@Injectable()
class GetCountryCodesUseCase {
  final CountryCodeRepository _countryCodeRepository;

  GetCountryCodesUseCase(this._countryCodeRepository);

  Future<List<CountryCode>> call() => _countryCodeRepository.load();
}
