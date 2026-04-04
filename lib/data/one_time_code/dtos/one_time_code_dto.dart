import 'package:freezed_annotation/freezed_annotation.dart';

part 'one_time_code_dto.g.dart';

/// DTO for PairingCode response: POST /auth/pairing/register
/// Backend returns flat: { "code": "ABC123", "expires_in": 30 }
@JsonSerializable()
class OneTimeCodeDTO {
  final String code;
  @JsonKey(name: 'expires_in')
  final int expiresIn;

  OneTimeCodeDTO(this.code, this.expiresIn);

  Map<String, dynamic> toJson() => _$OneTimeCodeDTOToJson(this);

  factory OneTimeCodeDTO.fromJson(Map<String, dynamic> json) => _$OneTimeCodeDTOFromJson(json);
}
