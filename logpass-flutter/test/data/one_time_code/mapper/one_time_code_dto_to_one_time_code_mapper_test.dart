import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/data/one_time_code/dtos/one_time_code_dto.dart';
import 'package:logpass_me/data/one_time_code/mappers/one_time_code_dto_to_one_time_code_mapper.dart';
import 'package:logpass_me/domain/one_time_code/one_time_code.dart';

void main() {
  late OneTimeCodeDTOToOneTimeCodeMapper mapper;

  setUp(() {
    mapper = OneTimeCodeDTOToOneTimeCodeMapper();
  });

  const expiresIn = 2;
  final createdDate = DateTime(2021, 12, 2, 12, 00, 00);
  final expirationDate = DateTime(2022, 12, 2, 12, 35, 00);

  test('returns mapped oneTimeCode model', () async {

    withClock(
      Clock.fixed(createdDate), () {

        final data = OneTimeCodeDataDTO('code', expiresIn, createdDate, expirationDate);
        final oneTimeCodeDTO = OneTimeCodeDTO(data);

        final action = mapper(oneTimeCodeDTO);
        final expectedExpiration = DateTime(2021, 12, 2, 12, 00, 02);

        expect(
            action,
            isA<OneTimeCode>()
                .having((a) => a.expirationTime, 'expirationTime', expectedExpiration)
        );
      },
    );
  });
}