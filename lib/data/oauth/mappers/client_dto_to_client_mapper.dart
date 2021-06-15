import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/data/model/enum/grant_type_dto_mapper.dart';
import 'package:logpass_me/data/model/enum/response_type_dto_mapper.dart';
import 'package:logpass_me/data/model/enum/scope_dto_mapper.dart';
import 'package:logpass_me/data/oauth/dtos/client_dto.dart';
import 'package:logpass_me/data/service/api/data/service_agreement_dto.dart';
import 'package:logpass_me/data/service/api/data/service_supported_scopes_dto.dart';
import 'package:logpass_me/domain/oauth/client.dart';

@injectable
class ClientDTOToClientMapper extends DataMapper<ClientDTO, Client> {
  final ServiceSupportedScopesDTOMapper _serviceSupportedScopesDTOMapper;
  final ScopeDTOMapper _scopeDTOMapper;
  final ResponseTypeDTOMapper _responseTypeDTOMapper;
  final GrantTypeDTOMapper _grantTypeDTOMapper;
  final ServiceAgreementDTOMapper _serviceAgreementDTOMapper;

  ClientDTOToClientMapper(
    this._scopeDTOMapper,
    this._responseTypeDTOMapper,
    this._grantTypeDTOMapper,
    this._serviceAgreementDTOMapper,
    this._serviceSupportedScopesDTOMapper,
  );

  @override
  Client call(ClientDTO data) {
    return Client(
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
    );
  }
}
