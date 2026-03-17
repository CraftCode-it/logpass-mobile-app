import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/data/event_log/api/dto/event_log_response_dto.dart';
import 'package:logpass_me/data/event_log/api/event_log_api_data_source.dart';
import 'package:logpass_me/data/event_log/event_log_repository_impl.dart';
import 'package:logpass_me/data/event_log/mapper/event_log_bundle_dto_mapper.dart';
import 'package:logpass_me/data/networking/error/logpass_dio_error_wrapper.dart';
import 'package:logpass_me/domain/event_log/event_log_bundle.dart';
import 'package:logpass_me/domain/networking/error/logpass_api_error.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'event_log_repository_impl_test.mocks.dart';

class FakeEventLogResponseDTO extends Fake implements EventLogResponseDTO {}

class FakeLogpassDioErrorWrapper extends Fake implements LogpassDioErrorWrapper {
  final LogpassApiError mockedError;

  FakeLogpassDioErrorWrapper(this.mockedError);

  @override
  LogpassApiError get logpassApiError => mockedError;
}

@GenerateMocks(
  [
    EventLogApiDataSource,
    EventLogBundleDTOMapper,
  ],
)
void main() {
  late MockEventLogApiDataSource eventLogApiDataSource;
  late MockEventLogBundleDTOMapper eventLogBundleDTOMapper;
  late EventLogRepositoryImpl eventLogRepositoryImpl;

  setUp(() {
    eventLogApiDataSource = MockEventLogApiDataSource();
    eventLogBundleDTOMapper = MockEventLogBundleDTOMapper();
    eventLogRepositoryImpl = EventLogRepositoryImpl(
      eventLogApiDataSource,
      eventLogBundleDTOMapper,
    );
  });

  const page = 0;

  test('returns EventLogs result on success', () async {

    final response = FakeEventLogResponseDTO();
    final expected = EventLogBundle(5, []);

    when(eventLogApiDataSource.getEventLogList(page)).thenAnswer((realInvocation) async => response);
    when(eventLogBundleDTOMapper(response)).thenAnswer((realInvocation) => expected);

    final result = await eventLogRepositoryImpl.getPageOfEventLogs(page);

    expect(result, expected);
  });

  test('throws error when api call fails', () async {
    final expected = Error();

    when(eventLogApiDataSource.getEventLogList(page)).thenAnswer((realInvocation) => throw expected);

    expect(eventLogRepositoryImpl.getPageOfEventLogs(page), throwsA(expected));
  });
}