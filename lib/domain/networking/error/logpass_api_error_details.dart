import 'package:freezed_annotation/freezed_annotation.dart';

part 'logpass_api_error_details.freezed.dart';
part 'logpass_api_error_details.g.dart';

@Freezed(unionKey: 'code', fallbackUnion: 'undefined')
class LogpassApiErrorDetails with _$LogpassApiErrorDetails {
  @FreezedUnionValue('verification_failed')
  factory LogpassApiErrorDetails.code(String message, String? pointer) = LogpassApiErrorDetailsCode;

  @FreezedUnionValue('undefined')
  factory LogpassApiErrorDetails.undefined(String code, String message, String? pointer) =
      LogpassApiErrorDetailsUndefined;

  factory LogpassApiErrorDetails.fromJson(Map<String, dynamic> json) => _$LogpassApiErrorDetailsFromJson(json);
}
