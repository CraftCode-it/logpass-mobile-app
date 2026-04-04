import 'package:clock/clock.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/data/one_time_code/dtos/one_time_code_dto.dart';
import 'package:logpass_me/domain/one_time_code/one_time_code.dart';

@injectable
class OneTimeCodeDTOToOneTimeCodeMapper implements DataMapper<OneTimeCodeDTO, OneTimeCode> {
  @override
  OneTimeCode call(OneTimeCodeDTO data) {
    final now = clock.now();
    final expirationSec = Duration(seconds: data.expiresIn);
    final expirationTime = now.add(expirationSec);

    return OneTimeCode(
      data.code,
      expirationSec,
      now,
      expirationTime,
    );
  }
}
