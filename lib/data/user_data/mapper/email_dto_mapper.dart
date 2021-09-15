import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/user_data/dto/email_dto.dart';
import 'package:logpass_me/data/user_data/mapper/hive_dto_mapper.dart';
import 'package:logpass_me/domain/user_data/data/email.dart';

@injectable
class EmailDtoMapper implements HiveDtoMapper<EmailDto, Email> {
  @override
  Email from(EmailDto dto) {
    return Email(
      dto.value,
      uuid: dto.uuid,
      isDefault: dto.isDefault,
    );
  }

  @override
  EmailDto to(Email mail) {
    return EmailDto(
      value: mail.value,
      isDefault: mail.isDefault,
      uuid: mail.uuid,
    );
  }
}
