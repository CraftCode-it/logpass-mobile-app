import 'package:json_annotation/json_annotation.dart';

part 'initialize_login_result_dto.g.dart';

@JsonSerializable()
class InitializeLoginResultDTO {
  final InitializeLoginResultDataDTO data;

  InitializeLoginResultDTO(this.data);

  Map<String, dynamic> toJson() => _$InitializeLoginResultDTOToJson(this);

  factory InitializeLoginResultDTO.fromJson(Map<String, dynamic> json) => _$InitializeLoginResultDTOFromJson(json);
}

@JsonSerializable()
class InitializeLoginResultDataDTO {
  final String verificationUrl;
  final String verificationMethod;
  final InitializeLoginResultVerificationDataDTO? verificationData;

  InitializeLoginResultDataDTO(this.verificationUrl, this.verificationMethod, this.verificationData);

  Map<String, dynamic> toJson() => _$InitializeLoginResultDataDTOToJson(this);

  factory InitializeLoginResultDataDTO.fromJson(Map<String, dynamic> json) =>
      _$InitializeLoginResultDataDTOFromJson(json);
}

@JsonSerializable()
class InitializeLoginResultVerificationDataDTO {
  final String toSign;

  InitializeLoginResultVerificationDataDTO(this.toSign);

  Map<String, dynamic> toJson() => _$InitializeLoginResultVerificationDataDTOToJson(this);

  factory InitializeLoginResultVerificationDataDTO.fromJson(Map<String, dynamic> json) =>
      _$InitializeLoginResultVerificationDataDTOFromJson(json);
}
