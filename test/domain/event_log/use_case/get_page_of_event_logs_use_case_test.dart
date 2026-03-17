import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/data/event_log/mapper/event_log_bundle_dto_mapper.dart';
import 'package:logpass_me/domain/event_log/event_log_bundle.dart';
import 'package:logpass_me/domain/event_log/event_log_repository.dart';
import 'package:logpass_me/domain/event_log/use_case/get_page_of_event_logs_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_page_of_event_logs_use_case_test.mocks.dart';

@GenerateMocks(
  [
    EventLogRepository,
    EventLogBundleDTOMapper
  ],
)
void main() {
  late EventLogRepository eventLogRepository;
  late GetPageOfEventLogsUseCase getPageOfEventLogsUseCase;

  setUp(() {
    eventLogRepository = MockEventLogRepository();
    getPageOfEventLogsUseCase = GetPageOfEventLogsUseCase(eventLogRepository);
  });

  const page = 1;
  test('it executes with success', () async {

    final expected = EventLogBundle(5, []);

    when(eventLogRepository.getPageOfEventLogs(page)).thenAnswer((_) async => expected);

    final result = await getPageOfEventLogsUseCase(page);

    verify(eventLogRepository.getPageOfEventLogs(page));
    expect(result, expected);
  });

  test('it throws error', () async {
    final expected = Error();

    when(eventLogRepository.getPageOfEventLogs(page)).thenAnswer((_) => throw expected);

    expect(() => getPageOfEventLogsUseCase(page), throwsA(expected));
  });
}