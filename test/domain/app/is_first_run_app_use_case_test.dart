import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/app/app_store.dart';
import 'package:logpass_me/domain/app/use_case/is_first_run_app_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'is_first_run_app_use_case_test.mocks.dart';

@GenerateMocks(
  [
    AppStore,
  ],
)
void main() {
  late AppStore appStore;
  late IsFirstRunAppUseCase useCase;

  setUp(() {
    appStore = MockAppStore();
    useCase = IsFirstRunAppUseCase(appStore);
  });

  test('it return first run app', () async {

    when(appStore.isFirstRun()).thenAnswer((_) async => true);
    when(appStore.markFirstRun()).thenAnswer((_) async => Future.value(null));

    final result = await useCase();

    expect(result, true);

    verify(appStore.isFirstRun()).called(1);
    verify(appStore.markFirstRun()).called(1);
  });

  test('it return not first run app', () async {
    when(appStore.isFirstRun()).thenAnswer((_) async => false);

    final result = await useCase();

    expect(result, false);

    verify(appStore.isFirstRun()).called(1);
    verifyNever(appStore.markFirstRun());
  });

  test('it throws error during getting first app run value', () {
    final expected = Error();

    when(appStore.isFirstRun()).thenThrow(expected);

    expect(useCase(), throwsA(expected));
  });

  test('it throws error during marking first app run', () {
    final expected = Error();

    when(appStore.isFirstRun()).thenAnswer((_) async => true);
    when(appStore.markFirstRun()).thenThrow(expected);

    final result = useCase();

    expect(result, throwsA(expected));
    verify(appStore.isFirstRun()).called(1);
  });
}
