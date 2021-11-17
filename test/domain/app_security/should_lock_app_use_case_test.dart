import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/app_security/app_lifecycle_store.dart';
import 'package:logpass_me/domain/app_security/app_security_store.dart';
import 'package:logpass_me/domain/app_security/app_security_type.dart';
import 'package:logpass_me/domain/app_security/use_case/should_lock_app_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'should_lock_app_use_case_test.mocks.dart';

@GenerateMocks(
  [
    AppSecurityStore,
    AppLifeCycleStore,
  ],
)
const _timeoutedTime = 31 * 1000;

void main() {
  late MockAppSecurityStore securityStore;
  late MockAppLifeCycleStore appLifecycleStore;
  late ShouldLockAppUseCase useCase;
  setUp(() {
    securityStore = MockAppSecurityStore();
    appLifecycleStore = MockAppLifeCycleStore();
    useCase = ShouldLockAppUseCase(securityStore, appLifecycleStore);
    when(appLifecycleStore.wasInBackground()).thenAnswer((realInvocation) async => null);
    when(appLifecycleStore.getAppBackgroundTime()).thenAnswer((realInvocation) async => null);
  });

  test('when app was longer in background than timeout time  and biometrics enabled then should return true', () async {
    when(securityStore.loadSecurityType()).thenAnswer((_) async => AppSecurityType.code);
    when(appLifecycleStore.getAppBackgroundTime())
        .thenAnswer((realInvocation) async => DateTime.now().millisecondsSinceEpoch - _timeoutedTime);
    final result = await useCase();
    expect(result, true);
  });

  test('when app was shorter time in background than timeout and biometrics enabled then should return false',
      () async {
    when(securityStore.loadSecurityType()).thenAnswer((_) async => AppSecurityType.code);
    when(appLifecycleStore.getAppBackgroundTime())
        .thenAnswer((realInvocation) async => DateTime.now().millisecondsSinceEpoch);
    when(appLifecycleStore.wasInBackground()).thenAnswer((realInvocation) async => true);
    final result = await useCase();
    expect(result, false);
  });

  test('when app runs from killed state and biometrics enabled then should return true', () async {
    when(securityStore.loadSecurityType()).thenAnswer((_) async => AppSecurityType.code);
    final result = await useCase();
    expect(result, true);
  });

  test('when app runs from killed state and biometrics disabled then should return false', () async {
    when(securityStore.loadSecurityType()).thenAnswer((_) async => AppSecurityType.none);
    final result = await useCase();
    expect(result, false);
  });
}
