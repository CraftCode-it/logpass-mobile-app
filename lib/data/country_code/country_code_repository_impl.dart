import 'package:country_codes/country_codes.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
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
  bool _countryCodesInitialized = false;

  CountryCodeRepositoryImpl(this._dataSource, this._mapper);

  @override
  Future<List<CountryCode>> load(String languageCode) async {
    final cache = _countryCodeListCache;
    if (cache != null) return cache;

    if (!_countryCodesInitialized) {
      try {
        await CountryCodes.init(Locale(languageCode));
        _countryCodesInitialized = true;
      } catch (e, s) {
        Fimber.w('CountryCodes.init failed, using fallback country names', ex: e, stacktrace: s);
      }
    }
    
    final entityList = await _dataSource.load();
    final countryCodeList =
        entityList.map<CountryCode>((entity) => _mapper(entity, languageCode)).toList(growable: false);

    _countryCodeListCache = countryCodeList;

    return countryCodeList;
  }
}
