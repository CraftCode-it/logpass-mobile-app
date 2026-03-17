import 'package:freezed_annotation/freezed_annotation.dart';

part 'denied_confirmation_dto.g.dart';

@JsonSerializable()
class DeniedConfirmationDTO {
  final DeniedConfirmationDataDTO data;

  DeniedConfirmationDTO(this.data);

  Map<String, dynamic> toJson() => _$DeniedConfirmationDTOToJson(this);

  factory DeniedConfirmationDTO.fromJson(Map<String, dynamic> json) => _$DeniedConfirmationDTOFromJson(json);
}

@JsonSerializable()
class DeniedConfirmationDataDTO {
  final String error;
  final String errorDescription;
  final String? state;
  final String redirectUri;

  DeniedConfirmationDataDTO(
    this.error,
    this.errorDescription,
    this.state,
    this.redirectUri,
  );

  Map<String, dynamic> toJson() => _$DeniedConfirmationDataDTOToJson(this);

  factory DeniedConfirmationDataDTO.fromJson(Map<String, dynamic> json) => _$DeniedConfirmationDataDTOFromJson(json);
}
