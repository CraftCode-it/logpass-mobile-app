import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/domain/auth/error/login_verification_error.dart';
import 'package:logpass_me/domain/networking/error/logpass_api_error.dart';
import 'package:logpass_me/domain/networking/error/logpass_api_error_details.dart';

void main() {
  late LoginVerificationErrorMapper mapper;

  setUp(() {
    mapper = LoginVerificationErrorMapper();
  });

  test('returns invalid code error', () {
    final codeErrorDetails = LogpassApiErrorDetails.code('Code message', 'pointer');
    final apiError = LogpassApiError.verificationFailed(
      'Api message',
      [
        codeErrorDetails,
      ],
    );
    final expected = LoginVerificationError.invalidCode(codeErrorDetails.message);

    final actual = mapper(apiError);

    expect(actual, expected);
  });

  test('rethrows error when unknown', () {
    final apiError = LogpassApiError.undefined(
      'code',
      'Api message',
      [],
    );

    expect(() => mapper(apiError), throwsA(apiError));
  });
}
