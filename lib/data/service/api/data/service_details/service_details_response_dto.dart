import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/data/service/api/data/service_dto.dart';

part 'service_details_response_dto.g.dart';

@JsonSerializable()
class ServiceDetailsResponseDTO {
  final ServiceDTO data;

  ServiceDetailsResponseDTO(this.data);

  factory ServiceDetailsResponseDTO.fromJson(Map<String, dynamic> json) => _$ServiceDetailsResponseDTOFromJson(json);
}
