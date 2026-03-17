import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/domain/networking/error/logpass_api_error_details.dart';

part 'logpass_api_error.freezed.dart';
part 'logpass_api_error.g.dart';

@Freezed(unionKey: 'code', fallbackUnion: 'undefined')
class LogpassApiError with _$LogpassApiError {
  @FreezedUnionValue('verification_failed')
  factory LogpassApiError.verificationFailed(
    String message,
    List<LogpassApiErrorDetails> errors,
  ) = LogpassApiErrorVerificationFailed;

  @FreezedUnionValue('throttled')
  factory LogpassApiError.throttled(
    String message,
    List<LogpassApiErrorDetails> errors,
  ) = LogpassApiErrorThrottled;

  @FreezedUnionValue('undefined')
  factory LogpassApiError.undefined(
    String code,
    String message,
    List<LogpassApiErrorDetails> errors,
  ) = LogpassApiErrorUndefined;

  factory LogpassApiError.fromJson(Map<String, dynamic> json) => _$LogpassApiErrorFromJson(json);
}
