import 'package:freezed_annotation/freezed_annotation.dart';

part 'one_time_code_parameter_dto.g.dart';

@JsonSerializable()
class OneTimeCodeParameterDTO {
  final bool forceRefresh;

  OneTimeCodeParameterDTO(this.forceRefresh);

  Map<String, dynamic> toJson() => _$OneTimeCodeParameterDTOToJson(this);

  factory OneTimeCodeParameterDTO.fromJson(Map<String, dynamic> json) => _$OneTimeCodeParameterDTOFromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OneTimeCodeParameterDTO && runtimeType == other.runtimeType && forceRefresh == other.forceRefresh;

  @override
  int get hashCode => forceRefresh.hashCode;
}
