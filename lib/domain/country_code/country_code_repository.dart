import 'package:logpass_me/domain/country_code/country_code.dart';

abstract class CountryCodeRepository {
  Future<List<CountryCode>> load(String languageCode);
}
