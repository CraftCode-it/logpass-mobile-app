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
import 'package:logpass_me/domain/service/data/service_with_tokens.dart';

part 'service_with_tokens_dto.g.dart';

@JsonSerializable()
class ServiceWithTokensDTO {
  final String clientId;
  final String name;
  final String url;
  final String logo;
  final String email;
  final List<ServiceSupportedScopesDTO> scopesSupported;
  final List<String> requiredScopes;
  final List<String> responseTypes;
  final List<String> grantTypes;
  final List<ServiceAgreementDTO> agreements;
  final ServiceTokensDTO tokens;

  ServiceWithTokensDTO(
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

  factory ServiceWithTokensDTO.fromJson(Map<String, dynamic> json) => _$ServiceWithTokensDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceWithTokensDTOToJson(this);
}

@Injectable()
class ServiceWithTokensDTOMapper implements BidirectionalDataMapper<ServiceWithTokens, ServiceWithTokensDTO> {
  final ServiceSupportedScopesDTOMapper _serviceSupportedScopesDTOMapper;
  final ScopeDTOMapper _scopeDTOMapper;
  final ResponseTypeDTOMapper _responseTypeDTOMapper;
  final GrantTypeDTOMapper _grantTypeDTOMapper;
  final ServiceAgreementDTOMapper _serviceAgreementDTOMapper;
  final ServiceTokensDTOMapper _serviceTokensDTOMapper;

  ServiceWithTokensDTOMapper(
    this._serviceSupportedScopesDTOMapper,
    this._scopeDTOMapper,
    this._responseTypeDTOMapper,
    this._grantTypeDTOMapper,
    this._serviceAgreementDTOMapper,
    this._serviceTokensDTOMapper,
  );

  @override
  ServiceWithTokensDTO from(ServiceWithTokens data) {
    return ServiceWithTokensDTO(
      data.service.clientId,
      data.service.name,
      data.service.url,
      data.service.logo,
      data.service.email,
      data.service.scopesSupported.map(_serviceSupportedScopesDTOMapper.from).toList(),
      data.service.requiredScopes.map(_scopeDTOMapper.from).toList(),
      data.service.responseTypes.map(_responseTypeDTOMapper.from).toList(),
      data.service.grantTypes.map(_grantTypeDTOMapper.from).toList(),
      data.service.agreements.map(_serviceAgreementDTOMapper.from).toList(),
      _serviceTokensDTOMapper.from(data.tokens),
    );
  }

  @override
  ServiceWithTokens to(ServiceWithTokensDTO data) {
    return ServiceWithTokens(
      service: Service(
        clientId: data.clientId,
        name: data.name,
        url: data.url,
        logo: data.logo,
        email: data.email,
        scopesSupported: data.scopesSupported.map(_serviceSupportedScopesDTOMapper.to).toList(),
        requiredScopes: data.requiredScopes.map(_scopeDTOMapper.to).toList(),
        responseTypes: data.responseTypes.map(_responseTypeDTOMapper.to).toList(),
        grantTypes: data.grantTypes.map(_grantTypeDTOMapper.to).toList(),
        agreements: data.agreements.map(_serviceAgreementDTOMapper.to).toList(),
      ),
      tokens: _serviceTokensDTOMapper.to(data.tokens),
    );
  }
}
