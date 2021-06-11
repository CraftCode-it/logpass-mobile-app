import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/data/networking/model/response_pagination_metadata_dto.dart';
import 'package:logpass_me/data/service/api/data/session/service_session_dto.dart';
import 'package:logpass_me/domain/service/data/session/service_sessions_bundle.dart';

part 'service_session_list_response_dto.g.dart';

@JsonSerializable()
class ServiceSessionListResponseDTO {
  @JsonKey(name: '_meta')
  final ResponsePaginationMetadataDTO metadata;
  final List<ServiceSessionDTO> data;

  ServiceSessionListResponseDTO(this.metadata, this.data);

  factory ServiceSessionListResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$ServiceSessionListResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceSessionListResponseDTOToJson(this);
}

@Injectable()
class ServiceSessionsBundleDTOMapper implements DataMapper<ServiceSessionListResponseDTO, ServiceSessionsBundle> {
  final ServiceSessionDTOMapper _serviceSessionDTOMapper;

  ServiceSessionsBundleDTOMapper(this._serviceSessionDTOMapper);

  @override
  ServiceSessionsBundle call(ServiceSessionListResponseDTO data) {
    return ServiceSessionsBundle(
      data.metadata.totalCount,
      data.data.map(_serviceSessionDTOMapper.to).toList(),
    );
  }
}
