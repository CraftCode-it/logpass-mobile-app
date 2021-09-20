import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/user_data/dto/email_entity.dart';
import 'package:logpass_me/data/user_data/mapper/hive_dto_mapper.dart';
import 'package:logpass_me/domain/user_data/data/email.dart';

@injectable
class EmailDtoMapper implements HiveDtoMapper<EmailEntity, Email> {
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
