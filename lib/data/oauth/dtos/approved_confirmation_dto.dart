import 'package:json_annotation/json_annotation.dart';

part 'approved_confirmation_dto.g.dart';

@JsonSerializable()
class ApprovedConfirmationDTO {
  final ApprovedConfirmationDataDTO data;

  ApprovedConfirmationDTO(this.data);

  Map<String, dynamic> toJson() => _$ApprovedConfirmationDTOToJson(this);

  factory ApprovedConfirmationDTO.fromJson(Map<String, dynamic> json) => _$ApprovedConfirmationDTOFromJson(json);
}

@JsonSerializable()
class ApprovedConfirmationDataDTO {
  final String code;
  final String? state;
  final String redirectUri;

  ApprovedConfirmationDataDTO(
    this.code,
    this.state,
    this.redirectUri,
  );

  Map<String, dynamic> toJson() => _$ApprovedConfirmationDataDTOToJson(this);

  factory ApprovedConfirmationDataDTO.fromJson(Map<String, dynamic> json) =>
      _$ApprovedConfirmationDataDTOFromJson(json);
}
