import 'package:bloc_test/bloc_test.dart' hide verify, when, verifyNever, any;
import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/domain/service/data/service_tokens.dart';
import 'package:logpass_me/domain/service/data/services_bundle.dart';
import 'package:logpass_me/domain/service/use_case/get_page_of_services_use_case.dart';
import 'package:logpass_me/presentation/page/session_list/service_list_page_cubit.dart';
import 'package:logpass_me/presentation/page/session_list/service_list_page_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'service_list_page_cubit_test.mocks.dart';

class FakeService extends Fake implements Service {
  final int count;

  FakeService(this.count);

  @override
  ServiceTokens get tokens => ServiceTokens(totalCount: count, activeCount: count);
}

@GenerateMocks(
  [
    GetPageOfServicesUseCase,
  ],
)
void main() {
  late MockGetPageOfServicesUseCase getPageOfServicesUseCase;
  late ServiceListPageCubit cubit;

  setUp(() {
    getPageOfServicesUseCase = MockGetPageOfServicesUseCase();
    cubit = ServiceListPageCubit(getPageOfServicesUseCase);
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
        await cubit.loadFirstPage();
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
