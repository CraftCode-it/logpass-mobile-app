import 'package:bloc_test/bloc_test.dart' hide verify, when, verifyNever, any;
import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/data_changed_notifier/data_changed_type.dart';
import 'package:logpass_me/domain/data_changed_notifier/use_case/listen_for_data_changed_use_case.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/service/data/service_tokens.dart';
import 'package:logpass_me/domain/service/data/service_with_tokens.dart';
import 'package:logpass_me/domain/service/data/services_bundle.dart';
import 'package:logpass_me/domain/service/use_case/get_page_of_services_use_case.dart';
import 'package:logpass_me/presentation/page/service_list/service_list_page_cubit.dart';
import 'package:logpass_me/presentation/page/service_list/service_list_page_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'service_list_page_cubit_test.mocks.dart';

class FakeService extends Fake implements ServiceWithTokens {
  final int count;

  FakeService(this.count);

  @override
  ServiceTokens get tokens => ServiceTokens(totalCount: count, activeCount: count);
}

@GenerateMocks(
  [
    GetPageOfServicesUseCase,
    ListenForDataChangedUseCase,
  ],
)
void main() {
  late MockGetPageOfServicesUseCase getPageOfServicesUseCase;
  late MockListenForDataChangedUseCase listenForDataChangedUseCase;
  late ServiceListPageCubit cubit;

  setUp(() {
    getPageOfServicesUseCase = MockGetPageOfServicesUseCase();
    listenForDataChangedUseCase = MockListenForDataChangedUseCase();
    cubit = ServiceListPageCubit(getPageOfServicesUseCase, listenForDataChangedUseCase);
  });

  final serviceBundle = ServicesBundle(
    10,
    [
      FakeService(3),
      FakeService(2),
      FakeService(2),
      FakeService(0),
      FakeService(0),
    ],
  );
  final serviceBundle2 = ServicesBundle(
    10,
    [
      FakeService(0),
      FakeService(0),
      FakeService(0),
      FakeService(0),
      FakeService(0),
    ],
  );

  group('initialize', () {
    blocTest<ServiceListPageCubit, ServiceListPageState>(
      'loads first page',
      build: () {
        when(getPageOfServicesUseCase(1)).thenAnswer((realInvocation) async => serviceBundle);
        when(listenForDataChangedUseCase(DataChangedType.service)).thenAnswer((realInvocation) => const Stream.empty());
        return cubit;
      },
      act: (cubit) => cubit.initialize(),
      expect: () => [
        ServiceListPageState.loading(),
        ServiceListPageState.idle(
          serviceBundle.services.getRange(0, 3).toList(),
          serviceBundle.services.getRange(3, serviceBundle.services.length).toList(),
          false,
        ),
      ],
    );

    blocTest<ServiceListPageCubit, ServiceListPageState>(
      'reloads first page when data changed notifier emits',
      build: () {
        when(getPageOfServicesUseCase(1)).thenAnswer((realInvocation) async => serviceBundle);
        when(listenForDataChangedUseCase(DataChangedType.service)).thenAnswer(
          (realInvocation) => Stream.fromFuture(
            Future.delayed(const Duration(milliseconds: 500), () => DataChangedType.service),
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.initialize(),
      wait: const Duration(seconds: 1),
      expect: () => [
        ServiceListPageState.loading(),
        ServiceListPageState.idle(
          serviceBundle.services.getRange(0, 3).toList(),
          serviceBundle.services.getRange(3, serviceBundle.services.length).toList(),
          false,
        ),
        ServiceListPageState.loading(),
        ServiceListPageState.idle(
          serviceBundle.services.getRange(0, 3).toList(),
          serviceBundle.services.getRange(3, serviceBundle.services.length).toList(),
          false,
        ),
      ],
    );
  });

  group('loadFirstPage', () {
    final connectionError = GeneralConnectionError.noConnection();

    blocTest<ServiceListPageCubit, ServiceListPageState>(
      'loads first page with success',
      build: () {
        when(getPageOfServicesUseCase(1)).thenAnswer((realInvocation) async => serviceBundle);
        return cubit;
      },
      act: (cubit) => cubit.loadFirstPage(),
      expect: () => [
        ServiceListPageState.loading(),
        ServiceListPageState.idle(
          serviceBundle.services.getRange(0, 3).toList(),
          serviceBundle.services.getRange(3, serviceBundle.services.length).toList(),
          false,
        ),
      ],
    );

    blocTest<ServiceListPageCubit, ServiceListPageState>(
      'on unknown error emits [Empty] state',
      build: () {
        when(getPageOfServicesUseCase(1)).thenAnswer((realInvocation) => throw Error());
        return cubit;
      },
      act: (cubit) => cubit.loadFirstPage(),
      expect: () => [
        ServiceListPageState.loading(),
        ServiceListPageState.empty(),
      ],
    );

    blocTest<ServiceListPageCubit, ServiceListPageState>(
      'on connection error emits [ConnectionError, Empty] states',
      build: () {
        when(getPageOfServicesUseCase(1)).thenAnswer((realInvocation) => throw connectionError);
        return cubit;
      },
      act: (cubit) => cubit.loadFirstPage(),
      expect: () => [
        ServiceListPageState.loading(),
        ServiceListPageState.connectionError(connectionError),
        ServiceListPageState.empty(),
      ],
    );
  });

  group('loadNextPage', () {
    blocTest<ServiceListPageCubit, ServiceListPageState>(
      'does not load next page if first one was not loaded yet',
      build: () => cubit,
      act: (cubit) => cubit.loadNextPage(),
      expect: () => [],
      verify: (cubit) {
        verifyNever(getPageOfServicesUseCase(any));
      },
    );

    group('when initialized', () {
      setUp(() async {
        when(getPageOfServicesUseCase(1)).thenAnswer((realInvocation) async => serviceBundle);
        when(listenForDataChangedUseCase(DataChangedType.service)).thenAnswer((realInvocation) => const Stream.empty());
        await cubit.initialize();
      });

      blocTest<ServiceListPageCubit, ServiceListPageState>(
        'loads next page with success',
        build: () {
          when(getPageOfServicesUseCase(2)).thenAnswer(
            (realInvocation) async => Future.delayed(const Duration(milliseconds: 500), () => serviceBundle2),
          );
          return cubit;
        },
        act: (cubit) => cubit.loadNextPage(),
        expect: () => [
          ServiceListPageState.idle(
            serviceBundle.services.getRange(0, 3).toList(),
            serviceBundle.services.getRange(3, serviceBundle.services.length).toList(),
            true,
          ),
          ServiceListPageState.idle(
            serviceBundle.services.getRange(0, 3).toList(),
            serviceBundle.services.getRange(3, serviceBundle.services.length).toList()..addAll(serviceBundle2.services),
            false,
          ),
        ],
      );

      blocTest<ServiceListPageCubit, ServiceListPageState>(
        'loads only one page same time',
        build: () {
          when(getPageOfServicesUseCase(2)).thenAnswer((realInvocation) async => serviceBundle2);
          return cubit;
        },
        act: (cubit) {
          cubit.loadNextPage();
          cubit.loadNextPage();
        },
        expect: () => [
          ServiceListPageState.idle(
            serviceBundle.services.getRange(0, 3).toList(),
            serviceBundle.services.getRange(3, serviceBundle.services.length).toList(),
            true,
          ),
          ServiceListPageState.idle(
            serviceBundle.services.getRange(0, 3).toList(),
            serviceBundle.services.getRange(3, serviceBundle.services.length).toList()..addAll(serviceBundle2.services),
            false,
          ),
        ],
      );
    });
  });
}
