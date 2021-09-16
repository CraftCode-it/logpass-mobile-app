import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/user_data/dto/personal_data_entity.dart';
import 'package:logpass_me/data/user_data/mapper/hive_dto_mapper.dart';
import 'package:logpass_me/domain/user_data/data/personal_data.dart';

@injectable
class PersonalDataDtoMapper implements HiveDtoMapper<PersonalDataEntity, PersonalData> {
  @override
  PersonalData from(PersonalDataEntity dto) {
    return PersonalData(
      name: dto.name,
      uuid: dto.uuid,
      isDefault: dto.isDefault,
      surname: dto.surname,
    );
  }

  @override
  PersonalDataEntity to(PersonalData invoice) {
    return PersonalDataEntity(
      name: invoice.name,
      surname: invoice.surname,
      isDefault: invoice.isDefault,
      uuid: invoice.uuid,
    );
  }
}
