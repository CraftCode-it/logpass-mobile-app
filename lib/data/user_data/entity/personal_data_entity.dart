import 'package:hive_flutter/hive_flutter.dart';
import 'package:logpass_me/data/database/database_configuration.dart';
import 'package:logpass_me/data/user_data/entity/hive_entity.dart';import 'package:logpass_me/domain/user_data/data/invoice_data.dart';

part 'personal_data_entity.g.dart';

@HiveType(typeId: HiveTypesIds.PERSONAL_DATA_DTO_TYPE)
class PersonalDataEntity extends HiveObject implements HiveEntity<PersonalDataEntity> {
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

  PersonalDataEntity({
    required this.name,
    required this.surname,
    required this.isDefault,
    required this.uuid,
  });

  @override
  PersonalDataEntity copyWith({
    String? name,
    String? surname,
    bool? isDefault,
    String? uuid,
  }) {
    return PersonalDataEntity(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      isDefault: isDefault ?? this.isDefault,
      uuid: uuid ?? this.uuid,
    );
  }
}
