import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/user_data/entity/email_entity.dart';
import 'package:logpass_me/data/user_data/mapper/entity/hive_entity_mapper.dart';
import 'package:logpass_me/domain/user_data/data/email.dart';

@injectable
class EmailEntityMapper implements HiveEntityMapper<EmailEntity, Email> {
  @override
  Email from(EmailEntity dto) {
    return Email(
      dto.value,
      uuid: dto.uuid,
      isDefault: dto.isDefault,
    );
  }

  @override
  EmailEntity to(Email mail) {
    return EmailEntity(
      value: mail.value,
      isDefault: mail.isDefault,
      uuid: mail.uuid,
    );
  }
}
