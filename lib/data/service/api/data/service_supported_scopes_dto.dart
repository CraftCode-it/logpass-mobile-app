import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logpass_me/data/common/bidirectional_data_mapper.dart';
import 'package:logpass_me/data/model/enum/scope_dto_mapper.dart';
import 'package:logpass_me/domain/service/data/service_supported_scopes.dart';

part 'service_supported_scopes_dto.g.dart';

@JsonSerializable()
class ServiceSupportedScopesDTO {
  final String scope;
  final String description;

  ServiceSupportedScopesDTO(this.scope, this.description);

  factory ServiceSupportedScopesDTO.fromJson(Map<String, dynamic> json) => _$ServiceSupportedScopesDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceSupportedScopesDTOToJson(this);
}

@Injectable()
class ServiceSupportedScopesDTOMapper
    implements BidirectionalDataMapper<ServiceSupportedScopes, ServiceSupportedScopesDTO> {
  final ScopeDTOMapper _scopeDTOMapper;

  ServiceSupportedScopesDTOMapper(this._scopeDTOMapper);

  @override
  ServiceSupportedScopesDTO from(ServiceSupportedScopes data) {
    return ServiceSupportedScopesDTO(
      _scopeDTOMapper.from(data.scope),
      data.description,
    );
  }

  @override
  ServiceSupportedScopes to(ServiceSupportedScopesDTO data) {
    return ServiceSupportedScopes(
      scope: _scopeDTOMapper.to(data.scope),
      description: data.description,
    );
  }
}
