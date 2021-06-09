import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logpass_me/data/common/bidirectional_data_mapper.dart';
import 'package:logpass_me/data/model/enum/grant_type_dto_mapper.dart';
import 'package:logpass_me/data/model/enum/response_type_dto_mapper.dart';
import 'package:logpass_me/data/model/enum/scope_dto_mapper.dart';
import 'package:logpass_me/data/service/api/data/service_agreement_dto.dart';
import 'package:logpass_me/data/service/api/data/service_supported_scopes_dto.dart';
import 'package:logpass_me/data/service/api/data/service_tokens_dto.dart';
import 'package:logpass_me/domain/service/data/service.dart';

part 'service_dto.g.dart';

@JsonSerializable()
class ServiceDTO {
  final String clientId;
  final String name;
  final String url;
  final String logo;
  final String email;
  final ServiceSupportedScopesDTO scopesSupported;
  final List<String> requiredScopes;
  final List<String> responseTypes;
  final List<String> grantTypes;
  final List<ServiceAgreementDTO> agreements;
  final ServiceTokensDTO tokens;

  ServiceDTO(
    this.clientId,
    this.name,
    this.url,
    this.logo,
    this.email,
    this.scopesSupported,
    this.requiredScopes,
    this.responseTypes,
    this.grantTypes,
    this.agreements,
    this.tokens,
  );

  factory ServiceDTO.fromJson(Map<String, dynamic> json) => _$ServiceDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceDTOToJson(this);
}

@Injectable()
class ServiceDTOMapper implements BidirectionalDataMapper<Service, ServiceDTO> {
  final ServiceSupportedScopesDTOMapper _serviceSupportedScopesDTOMapper;
  final ScopeDTOMapper _scopeDTOMapper;
  final ResponseTypeDTOMapper _responseTypeDTOMapper;
  final GrantTypeDTOMapper _grantTypeDTOMapper;
  final ServiceAgreementDTOMapper _serviceAgreementDTOMapper;
  final ServiceTokensDTOMapper _serviceTokensDTOMapper;

  ServiceDTOMapper(
    this._serviceSupportedScopesDTOMapper,
    this._scopeDTOMapper,
    this._responseTypeDTOMapper,
    this._grantTypeDTOMapper,
    this._serviceAgreementDTOMapper,
    this._serviceTokensDTOMapper,
  );

  @override
  ServiceDTO from(Service data) {
    return ServiceDTO(
      data.clientId,
      data.name,
      data.url,
      data.logo,
      data.email,
      _serviceSupportedScopesDTOMapper.from(data.scopesSupported),
      data.requiredScopes.map(_scopeDTOMapper.from).toList(),
      data.responseTypes.map(_responseTypeDTOMapper.from).toList(),
      data.grantTypes.map(_grantTypeDTOMapper.from).toList(),
      data.agreements.map(_serviceAgreementDTOMapper.from).toList(),
      _serviceTokensDTOMapper.from(data.tokens),
    );
  }

  @override
  Service to(ServiceDTO data) {
    return Service(
      clientId: data.clientId,
      name: data.name,
      url: data.url,
      logo: data.logo,
      email: data.email,
      scopesSupported: _serviceSupportedScopesDTOMapper.to(data.scopesSupported),
      requiredScopes: data.requiredScopes.map(_scopeDTOMapper.to).toList(),
      responseTypes: data.responseTypes.map(_responseTypeDTOMapper.to).toList(),
      grantTypes: data.grantTypes.map(_grantTypeDTOMapper.to).toList(),
      agreements: data.agreements.map(_serviceAgreementDTOMapper.to).toList(),
      tokens: _serviceTokensDTOMapper.to(data.tokens),
    );
  }
}
