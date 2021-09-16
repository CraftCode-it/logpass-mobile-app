import 'package:hive_flutter/hive_flutter.dart';
import 'package:logpass_me/data/database/database_configuration.dart';
import 'package:logpass_me/data/user_data/dto/hive_dto.dart';import 'package:logpass_me/domain/user_data/data/invoice_data.dart';

part 'personal_data_dto.g.dart';

@HiveType(typeId: HiveTypesIds.PERSONAL_DATA_DTO_TYPE)
class PersonalDataDto extends HiveObject implements HiveDto<PersonalDataDto> {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String surname;

  @override
  @HiveField(2)
  final bool isDefault;

  @override
  @HiveField(3)
  final String uuid;

  PersonalDataDto({
    required this.name,
    required this.surname,
    required this.isDefault,
    required this.uuid,
  });

  @override
  PersonalDataDto copyWith({
    String? name,
    String? surname,
    bool? isDefault,
    String? uuid,
  }) {
    return PersonalDataDto(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      isDefault: isDefault ?? this.isDefault,
      uuid: uuid ?? this.uuid,
    );
  }
}
