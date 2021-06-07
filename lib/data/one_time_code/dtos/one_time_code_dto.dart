import 'package:freezed_annotation/freezed_annotation.dart';

part 'one_time_code_dto.g.dart';

@JsonSerializable()
class OneTimeCodeDTO {
  final OneTimeCodeDataDTO data;

  OneTimeCodeDTO(this.data);

  Map<String, dynamic> toJson() => _$OneTimeCodeDTOToJson(this);

  factory OneTimeCodeDTO.fromJson(Map<String, dynamic> json) => _$OneTimeCodeDTOFromJson(json);
}

@JsonSerializable()
class OneTimeCodeDataDTO {
  final String code;
  final int expiresIn;
  final DateTime generatedAt;
  final DateTime validUntil;

  OneTimeCodeDataDTO(
    this.code,
    this.expiresIn,
    this.generatedAt,
    this.validUntil,
  );

  Map<String, dynamic> toJson() => _$OneTimeCodeDataDTOToJson(this);

  factory OneTimeCodeDataDTO.fromJson(Map<String, dynamic> json) => _$OneTimeCodeDataDTOFromJson(json);
}
