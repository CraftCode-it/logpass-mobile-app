import 'package:country_codes/country_codes.dart';
import 'package:flutter/rendering.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/country_code/country_code.dart';

part 'country_code_entity.g.dart';

@JsonSerializable()
class CountryCodeEntity {
  final String country;
  final String code;

  CountryCodeEntity(this.country, this.code);

  factory CountryCodeEntity.from(Map<String, dynamic> json) => _$CountryCodeEntityFromJson(json);

  Map<String, dynamic> toJson() => _$CountryCodeEntityToJson(this);
}

@Injectable()
class CountryCodeFromEntityMapper {
  CountryCode call(CountryCodeEntity data, String languageCode) {
    final countryName = _countryName(languageCode, data.country);

    return CountryCode(
      data.code,
      data.country,
      countryName,
    );
  }

  String _countryName(String languageCode, String countryCode) {
    try {

      final country = CountryCodes.detailsForLocale(
        Locale(
          languageCode,
          countryCode,
        ),
      );
      return country.localizedName ?? countryCode;
    } catch (e) {
      return countryCode;
    }
  }
}
