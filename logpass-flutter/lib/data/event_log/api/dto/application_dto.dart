import 'package:json_annotation/json_annotation.dart';

part 'application_dto.g.dart';

@JsonSerializable()
class ApplicationDTO {
  final String id;
  final String clientId;
  final String name;
  final String url;
  final String email;
  final String? logo;

  ApplicationDTO(this.id, this.clientId, this.name, this.url, this.email, this.logo);

  factory ApplicationDTO.fromJson(Map<String, dynamic> json) =>
      _$ApplicationDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicationDTOToJson(this);
}