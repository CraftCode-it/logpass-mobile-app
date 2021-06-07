import 'package:freezed_annotation/freezed_annotation.dart';

part 'one_time_code_parameter_dto.g.dart';

@JsonSerializable()
class OneTimeCodeParameterDTO {
  final bool forceRefresh;

  OneTimeCodeParameterDTO(this.forceRefresh);

  Map<String, dynamic> toJson() => _$OneTimeCodeParameterDTOToJson(this);

  factory OneTimeCodeParameterDTO.fromJson(Map<String, dynamic> json) => _$OneTimeCodeParameterDTOFromJson(json);
}
