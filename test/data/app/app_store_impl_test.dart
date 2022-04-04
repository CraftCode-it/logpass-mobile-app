import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/data/app/app_store_impl.dart';
import 'package:logpass_me/data/app/storage/app_database.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'app_store_impl_test.mocks.dart';

@GenerateMocks(
  [
    AppDatabase,
  ],
)
void main() {
  late AppDatabase appDatabase;
  late AppStoreImpl appStoreImpl;

  setUp(() {
    appDatabase = MockAppDatabase();
    appStoreImpl = AppStoreImpl(appDatabase);
  });

  group('return first app run', () {
    test('returns true when database is empty', () async {
      when(appDatabase.isFirstRun()).thenAnswer((_) async => null);

      final actual = await appStoreImpl.isFirstRun();

      expect(actual, true);
      verify(appDatabase.isFirstRun()).called(1);
    });

    test('returns true when database is not empty', () async {
      when(appDatabase.isFirstRun()).thenAnswer((_) async => true);

      final actual = await appStoreImpl.isFirstRun();

      expect(actual, true);
      verify(appDatabase.isFirstRun()).called(1);
    });

    test('returns false when we\'ve marked first run', () async {
      when(appDatabase.isFirstRun()).thenAnswer((_) async => false);

      final actual = await appStoreImpl.isFirstRun();

      expect(actual, false);
      verify(appDatabase.isFirstRun()).called(1);
    });
  });

  group('mark first run', () {
    test('mark first run in database', () async {
      when(appDatabase.markFirstRun()).thenAnswer((_) async {});

      await appStoreImpl.markFirstRun();

      verify(appDatabase.markFirstRun()).called(1);
    });
  });
}
