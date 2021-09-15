import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/user_data/dto/personal_data_dto.dart';
import 'package:logpass_me/data/user_data/mapper/hive_dto_mapper.dart';
import 'package:logpass_me/domain/user_data/data/personal_data.dart';

@injectable
class PersonalDataDtoMapper implements HiveDtoMapper<PersonalDataDto, PersonalData> {
  @override
  PersonalData from(PersonalDataDto dto) {
    return PersonalData(
      name: dto.name,
      uuid: dto.uuid,
      isDefault: dto.isDefault,
      surname: dto.surname,
    );
  }

  @override
  PersonalDataDto to(PersonalData invoice) {
    return PersonalDataDto(
      name: invoice.name,
      surname: invoice.surname,
      isDefault: invoice.isDefault,
      uuid: invoice.uuid,
    );
  }
}
