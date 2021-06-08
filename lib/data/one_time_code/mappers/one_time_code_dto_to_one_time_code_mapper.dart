import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/data/one_time_code/dtos/one_time_code_dto.dart';
import 'package:logpass_me/domain/one_time_code/one_time_code.dart';

@injectable
class OneTimeCodeDTOToOneTimeCodeMapper implements DataMapper<OneTimeCodeDTO, OneTimeCode> {
  @override
  OneTimeCode call(OneTimeCodeDTO data) {
    return OneTimeCode(
      data.data.code,
      _getExpirationInSec(data.data.expiresIn),
      data.data.generatedAt.toLocal(),
      data.data.validUntil.toLocal(),
    );
  }

  Duration _getExpirationInSec(int expiresIn) => Duration(seconds: expiresIn);
}
