import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/internet_connection/internet_connection_repository.dart';
import 'package:logpass_me/domain/internet_connection/use_case/dispose_internet_connection_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'dispose_internet_connection_use_case_test.mocks.dart';

@GenerateMocks(
  [
    InternetConnectionRepository,
  ],
)
void main() {
  late InternetConnectionRepository internetConnectionRepository;
  late DisposeInternetConnectionUseCase disposeInternetConnectionUseCase;

  setUp(() {
    internetConnectionRepository = MockInternetConnectionRepository();
    disposeInternetConnectionUseCase = DisposeInternetConnectionUseCase(internetConnectionRepository);
  });

  test('verify dispose calls', () async {
    when(internetConnectionRepository.dispose()).thenAnswer((_) async => {});

    await disposeInternetConnectionUseCase();

    verify(internetConnectionRepository.dispose());
  });

  test('it calls with error and throw exception', () async {
    final expected = Error();

    when(internetConnectionRepository.dispose()).thenAnswer((_) async => throw expected);

    expect(disposeInternetConnectionUseCase(), throwsA(expected));
  });
}