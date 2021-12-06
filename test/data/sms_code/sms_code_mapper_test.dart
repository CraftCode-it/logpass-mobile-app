import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/data/sms_code/sms_code_mapper.dart';

void main() {
  late SmsCodeMapper mapper;

  setUp(() {
    mapper = SmsCodeMapper();
  });

  test('returns mapped code', () {
    const sms = 'test 123456 test';
    const expected = '123456';

    final result = mapper(sms);

    expect(expected, result);
  });

  test('returns null if sms does not contain code', () {
    const sms = 'test test';
    const expected = null;

    final result = mapper(sms);

    expect(expected, result);
  });
}