import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/data/networking/model/response_pagination_metadata_dto.dart';
import 'package:logpass_me/data/service/api/data/service_dto.dart';
import 'package:logpass_me/data/service/api/data/service_with_tokens_dto.dart';
import 'package:logpass_me/domain/service/data/services_bundle.dart';

part 'authorized_services_response_dto.g.dart';

@JsonSerializable()
class AuthorizedServicesResponseDTO {
  @JsonKey(name: '_meta')
  final ResponsePaginationMetadataDTO metadata;
  final List<ServiceWithTokensDTO> data;

  AuthorizedServicesResponseDTO(this.metadata, this.data);

  factory AuthorizedServicesResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$AuthorizedServicesResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorizedServicesResponseDTOToJson(this);
}

@Injectable()
class ServiceBundleDTOMapper implements DataMapper<AuthorizedServicesResponseDTO, ServicesBundle> {
  final ServiceWithTokensDTOMapper serviceWithTokensDTOMapper;

  ServiceBundleDTOMapper(this.serviceWithTokensDTOMapper);

  @override
  ServicesBundle call(AuthorizedServicesResponseDTO data) {
    return ServicesBundle(
      data.metadata.totalCount,
      data.data.map(serviceWithTokensDTOMapper.to).toList(),
    );
  }
}
