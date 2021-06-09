import 'package:json_annotation/json_annotation.dart';
import 'package:logpass_me/data/service/api/data/service_dto.dart';

part 'authorized_services_response_dto.g.dart';

@JsonSerializable()
class AuthorizedServicesResponseDTO {
  final List<ServiceDTO> data;

  AuthorizedServicesResponseDTO(this.data);

  factory AuthorizedServicesResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$AuthorizedServicesResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorizedServicesResponseDTOToJson(this);
}
