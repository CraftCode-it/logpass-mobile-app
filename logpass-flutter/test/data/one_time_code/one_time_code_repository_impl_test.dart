import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/data/one_time_code/api/one_time_code_api_data_source.dart';
import 'package:logpass_me/data/one_time_code/dtos/one_time_code_dto.dart';
import 'package:logpass_me/data/one_time_code/dtos/one_time_code_parameter_dto.dart';
import 'package:logpass_me/data/one_time_code/mappers/one_time_code_dto_to_one_time_code_mapper.dart';
import 'package:logpass_me/data/one_time_code/one_time_code_repository_impl.dart';
import 'package:logpass_me/domain/one_time_code/one_time_code.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'one_time_code_repository_impl_test.mocks.dart';

class FakeOneTimeCodeDTO extends Fake implements OneTimeCodeDTO {}

@GenerateMocks(
  [
    OneTimeCodeApiDataSource,
    OneTimeCodeDTOToOneTimeCodeMapper,
  ],
)
void main() {
  late OneTimeCodeApiDataSource oneTimeCodeApiDataSource;
  late OneTimeCodeDTOToOneTimeCodeMapper dtoMapper;
  late OneTimeCodeRepositoryImpl oneTimeCodeRepositoryImpl;

  setUp(() {
    oneTimeCodeApiDataSource = MockOneTimeCodeApiDataSource();
    dtoMapper = MockOneTimeCodeDTOToOneTimeCodeMapper();
    oneTimeCodeRepositoryImpl = OneTimeCodeRepositoryImpl(oneTimeCodeApiDataSource, dtoMapper);
  });

  group('oneTimeCode manipulation', () {
    final dtoParameter = OneTimeCodeParameterDTO(false);
    final dtoOneTimeCode = FakeOneTimeCodeDTO();
    final oneTimeCode = OneTimeCode(
      'code',
      const Duration(seconds: 1),
      DateTime.now(),
      DateTime.now(),
    );

    test('subject contains returned oneTimeCode', () async {
      when(oneTimeCodeApiDataSource.getOneTimeCode(dtoParameter)).thenAnswer((realInvocation) async => dtoOneTimeCode);
      when(dtoMapper(dtoOneTimeCode)).thenAnswer((realInvocation) => oneTimeCode);

      await oneTimeCodeRepositoryImpl.loadOneTimeCode(false);
      final actual = await oneTimeCodeRepositoryImpl.listenForOneTimeCode().first;

      expect(actual, oneTimeCode);
    });

    test('throws an error when api call fails', () async {
      final error = Error();

      when(oneTimeCodeApiDataSource.getOneTimeCode(dtoParameter)).thenAnswer((realInvocation) => throw error);

      expect(oneTimeCodeRepositoryImpl.loadOneTimeCode(false), throwsA(error));
    });
  });
}
