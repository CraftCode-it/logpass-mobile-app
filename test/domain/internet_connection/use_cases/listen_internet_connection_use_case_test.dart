import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/internet_connection/internet_connection_repository.dart';
import 'package:logpass_me/domain/internet_connection/use_case/listen_internet_connection_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'listen_internet_connection_use_case_test.mocks.dart';

@GenerateMocks(
  [
    InternetConnectionRepository,
  ],
)
void main() {
  late InternetConnectionRepository internetConnectionRepository;
  late ListenInternetConnectionUseCase listenInternetConnectionUseCase;

  setUp(() {
    internetConnectionRepository = MockInternetConnectionRepository();
    listenInternetConnectionUseCase = ListenInternetConnectionUseCase(internetConnectionRepository);
  });

  test('listener emit value', () async {
    final stream = Stream.value(true);

    when(internetConnectionRepository.listenInternetConnection()).thenAnswer((_) => stream);

    final result = listenInternetConnectionUseCase();

    expect(result, stream);
  });
}