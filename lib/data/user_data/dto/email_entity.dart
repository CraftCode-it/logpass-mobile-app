import 'package:hive_flutter/hive_flutter.dart';
import 'package:logpass_me/data/database/database_configuration.dart';
import 'package:logpass_me/data/user_data/dto/hive_entity.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';

part 'email_entity.g.dart';

@HiveType(typeId: HiveTypesIds.EMAILS_DATA_DTO_TYPE)
class EmailEntity extends HiveObject implements HiveEntity<EmailEntity> {
  @HiveField(0)
  final String value;

  @override
  @HiveField(1)
  final bool isDefault;

  @override
  @HiveField(2)
  final String uuid;

  EmailEntity({
    required this.value,
    required this.isDefault,
    required this.uuid,
  });

  @override
  EmailEntity copyWith({
    String? value,
    bool? isDefault,
    String? uuid,
  }) {
    return EmailEntity(
      value: value ?? this.value,
      isDefault: isDefault ?? this.isDefault,
      uuid: uuid ?? this.uuid,
    );
  }
}
