import 'package:json_annotation/json_annotation.dart';

part 'initialize_login_result_dto.g.dart';

@JsonSerializable()
class InitializeLoginResultDTO {
  @JsonKey(name: '_links')
  final InitializeLoginLinksDTO links;
  final InitializeLoginResultDataDTO data;

  InitializeLoginResultDTO(this.links, this.data);

  Map<String, dynamic> toJson() => _$InitializeLoginResultDTOToJson(this);

  factory InitializeLoginResultDTO.fromJson(Map<String, dynamic> json) => _$InitializeLoginResultDTOFromJson(json);
}

@JsonSerializable()
class InitializeLoginLinksDTO {
  final String verification;

  InitializeLoginLinksDTO(this.verification);

  Map<String, dynamic> toJson() => _$InitializeLoginLinksDTOToJson(this);

  factory InitializeLoginLinksDTO.fromJson(Map<String, dynamic> json) => _$InitializeLoginLinksDTOFromJson(json);
}

@JsonSerializable()
class InitializeLoginResultDataDTO {
  final String id;
  final String verificationMethod;
  final InitializeLoginResultVerificationDataDTO? verificationData;

  InitializeLoginResultDataDTO(this.id, this.verificationMethod, this.verificationData);

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
