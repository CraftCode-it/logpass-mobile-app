import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/country_code/country_code_data_source.dart';
import 'package:logpass_me/data/country_code/country_code_entity.dart';
import 'package:logpass_me/domain/country_code/country_code.dart';
import 'package:logpass_me/domain/country_code/country_code_repository.dart';

@LazySingleton(as: CountryCodeRepository)
class CountryCodeRepositoryImpl implements CountryCodeRepository {
  final CountryCodeDataSource _dataSource;
  final CountryCodeFromEntityMapper _mapper;

  List<CountryCode>? _countryCodeListCache;

  CountryCodeRepositoryImpl(this._dataSource, this._mapper);

  @override
  Future<List<CountryCode>> load() async {
    final cache = _countryCodeListCache;
    if (cache != null) return cache;

    final entityList = await _dataSource.load();
    final countryCodeList = entityList.map<CountryCode>(_mapper).toList(growable: false);

    _countryCodeListCache = countryCodeList;

    return countryCodeList;
  }
}
