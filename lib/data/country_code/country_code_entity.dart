import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
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
class CountryCodeFromEntityMapper implements DataMapper<CountryCodeEntity, CountryCode> {
  @override
  CountryCode call(CountryCodeEntity data) {
    return CountryCode(
      data.code,
      data.country,
    );
  }
}
