import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/domain/networking/error/logpass_api_error.dart';
import 'package:logpass_me/domain/networking/error/logpass_api_error_details.dart';

part 'login_verification_error.freezed.dart';

@freezed
class LoginVerificationError with _$LoginVerificationError {
  factory LoginVerificationError.invalidCode(String message) = _LoginVerificationErrorInvalidCode;

  factory LoginVerificationError.accountAlreadyCreated() = _LoginVerificationErrorAccountAlreadyCreated;
}

@Injectable()
class LoginVerificationErrorMapper implements DataMapper<LogpassApiError, LoginVerificationError> {
  @override
  LoginVerificationError call(LogpassApiError data) {
    return data.maybeMap(
      verificationFailed: (error) {
        final codeError = error.errors.firstWhere((element) => element is LogpassApiErrorDetailsCode);
        return LoginVerificationError.invalidCode(codeError.message);
      },
      orElse: () => throw data,
    );
  }
}
