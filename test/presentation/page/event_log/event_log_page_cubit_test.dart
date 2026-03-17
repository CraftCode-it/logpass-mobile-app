import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/event_log/event_log.dart';
import 'package:logpass_me/domain/event_log/event_log_bundle.dart';
import 'package:logpass_me/domain/event_log/use_case/get_page_of_event_logs_use_case.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/presentation/page/event_log/event_log_page_cubit.dart';
import 'package:logpass_me/presentation/page/event_log/event_log_page_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'event_log_page_cubit_test.mocks.dart';

class FakeEventLog extends Fake implements EventLog {}

@GenerateMocks(
  [
    GetPageOfEventLogsUseCase,
  ],
)
void main() {
  late MockGetPageOfEventLogsUseCase getPageOfEventLogsUseCase;
  late EventLogPageCubit cubit;

  setUp(() {
    getPageOfEventLogsUseCase = MockGetPageOfEventLogsUseCase();
    cubit = EventLogPageCubit(getPageOfEventLogsUseCase);
  });

  final eventLogBundlePage1 = EventLogBundle(
    3,
    [ FakeEventLog(),
      FakeEventLog(),
      FakeEventLog(),
    ],
  );

  final eventLogBundlePage2 = EventLogBundle(
    2,
    [
      FakeEventLog(),
      FakeEventLog(),
    ],
  );

  group('initialize', () {
    blocTest<EventLogPageCubit, EventLogPageState>(
      'loads first page',
      build: () {
        when(getPageOfEventLogsUseCase(1)).thenAnswer((realInvocation) async => eventLogBundlePage1);
        return cubit;
      },
      act: (cubit) => cubit.initialize(),
      expect: () => [
        EventLogPageState.loading(),
        EventLogPageState.idle(eventLogBundlePage1.eventLogList, false),
      ],
    );
  });

  group('loadFirstPage', () {
    final connectionError = GeneralConnectionError.noConnection();

    blocTest<EventLogPageCubit, EventLogPageState>(
      'on unknown error emits [Empty] state',
      build: () {
        when(getPageOfEventLogsUseCase(1)).thenAnswer((realInvocation) => throw Error());
        return cubit;
      },
      act: (cubit) => cubit.loadFirstPage(),
      expect: () => [
        EventLogPageState.loading(),
        EventLogPageState.empty(),
      ],
    );

    blocTest<EventLogPageCubit, EventLogPageState>(
      'on connection error emits [ConnectionError, Empty] states',
      build: () {
        when(getPageOfEventLogsUseCase(1)).thenAnswer((realInvocation) => throw connectionError);
        return cubit;
      },
      act: (cubit) => cubit.loadFirstPage(),
      expect: () => [
        EventLogPageState.loading(),
        EventLogPageState.connectionError(connectionError),
        EventLogPageState.empty(),
      ],
    );
  });

  group('loadNextPage', () {
    blocTest<EventLogPageCubit, EventLogPageState>(
      'does not load next page if previous one is loading',
      build: () => cubit,
      act: (cubit) => cubit.loadNextPage(),
      expect: () => [],
      verify: (cubit) {
        verifyNever(getPageOfEventLogsUseCase(2));
      },
    );

    group('when initialized', () {
      setUp(() async {
        when(getPageOfEventLogsUseCase(1)).thenAnswer((realInvocation) async => eventLogBundlePage1);
        await cubit.initialize();
      });

      blocTest<EventLogPageCubit, EventLogPageState>(
        'loads next page with success',
        build: () {
          when(getPageOfEventLogsUseCase(2)).thenAnswer((realInvocation) async => eventLogBundlePage2);
          return cubit;
        },
        act: (cubit) => cubit.loadNextPage(),
        expect: () => [
          EventLogPageState.idle(eventLogBundlePage1.eventLogList, true),
          EventLogPageState.idle(
            List.from(eventLogBundlePage1.eventLogList)..addAll(eventLogBundlePage2.eventLogList),
            false,
          ),
        ],
      );

      blocTest<EventLogPageCubit, EventLogPageState>(
        'loads only one page same time',
        build: () {
          when(getPageOfEventLogsUseCase(2)).thenAnswer((realInvocation) async => eventLogBundlePage2);
          return cubit;
        },
        act: (cubit) {
          cubit.loadNextPage();
          cubit.loadNextPage();
        },
        expect: () => [
          EventLogPageState.idle(List.from(eventLogBundlePage1.eventLogList), true),
          EventLogPageState.idle(
            List.from(eventLogBundlePage1.eventLogList)..addAll(eventLogBundlePage2.eventLogList),
            false,
          ),
        ],
      );
    });
  });
}
