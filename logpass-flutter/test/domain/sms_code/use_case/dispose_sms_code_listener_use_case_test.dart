import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/sms_code/sms_code_repository.dart';
import 'package:logpass_me/domain/sms_code/use_case/dispose_sms_code_listener_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'dispose_sms_code_listener_use_case_test.mocks.dart';

@GenerateMocks(
  [
    SmsCodeRepository,
  ],
)
void main() {
  late MockSmsCodeRepository smsCodeRepository;
  late DisposeSmsCodeListenerUseCase disposeSmsCodeListenerUseCase;

  setUp(() {
    smsCodeRepository = MockSmsCodeRepository();
    disposeSmsCodeListenerUseCase = DisposeSmsCodeListenerUseCase(smsCodeRepository);
  });

  test('it executes success', () async {
    when(smsCodeRepository.dispose()).thenAnswer((_) async {});

    await disposeSmsCodeListenerUseCase();

    verify(smsCodeRepository.dispose()).called(1);
  });
}