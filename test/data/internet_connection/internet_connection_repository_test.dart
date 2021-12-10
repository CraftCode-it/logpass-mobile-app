import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/data/internet_connection/internet_connection_manager.dart';
import 'package:logpass_me/data/internet_connection/internet_connection_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'internet_connection_repository_test.mocks.dart';

@GenerateMocks(
  [
    InternetConnectionManager,
  ],
)
void main() {
  late InternetConnectionManager internetConnectionManager;
  late InternetConnectionRepositoryImpl internetConnectionRepositoryImpl;

  setUp(() {
    internetConnectionManager = MockInternetConnectionManager();
    internetConnectionRepositoryImpl = InternetConnectionRepositoryImpl(internetConnectionManager);
  });

  group('check internet connection', () {
    test('get internet connection state connected', () async {
      when(internetConnectionManager.hasInternetConnection()).thenAnswer((_) async => true);

      final result = await internetConnectionRepositoryImpl.hasInternetConnection();

      verify(internetConnectionManager.hasInternetConnection());
      expect(result, true);
    });

    test('get internet connection state disconnected', () async {
      when(internetConnectionManager.hasInternetConnection()).thenAnswer((_) async => false);

      final result = await internetConnectionRepositoryImpl.hasInternetConnection();

      verify(internetConnectionManager.hasInternetConnection());
      expect(result, false);
    });

    test('throws exception when there\'s problem with getting internet connection state', () async {
      final expected = Exception();

      when(internetConnectionManager.hasInternetConnection()).thenAnswer((_) async => throw expected);

      expect(internetConnectionRepositoryImpl.hasInternetConnection(), throwsA(expected));
    });
  });

  group('dispose internet connection listener', () {
    test('verify disposing process', () {
      when(internetConnectionManager.dispose()).thenAnswer((_) => {});

      internetConnectionRepositoryImpl.dispose();

      verify(internetConnectionManager.dispose());
    });
  });

  group('listen internet connection', () {
    test('listener emit disconnected state', () {
      final expected = Stream.value(false);

      when(internetConnectionManager.init()).thenAnswer((_) => {});
      when(internetConnectionManager.listenInternetConnection()).thenAnswer((_) => expected);

      final result = internetConnectionRepositoryImpl.listenInternetConnection();

      expect(result, expected);
    });

    test('listener emit connected state', () {
      final expected = Stream.value(true);

      when(internetConnectionManager.init()).thenAnswer((_) => {});
      when(internetConnectionManager.listenInternetConnection()).thenAnswer((_) => expected);

      final result = internetConnectionRepositoryImpl.listenInternetConnection();

      expect(result, expected);
    });

    test('verify listener process', () {
      final expected = Stream.value(true);

      when(internetConnectionManager.init()).thenAnswer((_) => {});
      when(internetConnectionManager.listenInternetConnection()).thenAnswer((_) => expected);

      internetConnectionRepositoryImpl.listenInternetConnection();

      verify(internetConnectionManager.init());
      verify(internetConnectionManager.listenInternetConnection());
    });
  });
}