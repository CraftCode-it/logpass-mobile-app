import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/internet_connection/internet_connection_repository.dart';
import 'package:logpass_me/domain/internet_connection/use_case/get_internet_connection_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_internet_connection_use_case_test.mocks.dart';

@GenerateMocks(
  [
    InternetConnectionRepository,
  ],
)
void main() {
  late InternetConnectionRepository internetConnectionRepository;
  late GetInternetConnectionUseCase getInternetConnectionUseCase;

  setUp(() {
    internetConnectionRepository = MockInternetConnectionRepository();
    getInternetConnectionUseCase = GetInternetConnectionUseCase(internetConnectionRepository);
  });

  test('it calls with success and return value', () async {
    when(internetConnectionRepository.hasInternetConnection()).thenAnswer((_) async => true);

    final result = await getInternetConnectionUseCase();

    expect(result, true);
    verify(internetConnectionRepository.hasInternetConnection());
  });

  test('it throws error on failure', () async {
    final expected = Error();

    when(internetConnectionRepository.hasInternetConnection()).thenAnswer((_) async => throw expected);

    expect(getInternetConnectionUseCase(), throwsA(expected));
  });
}