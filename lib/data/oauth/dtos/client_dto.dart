import 'package:json_annotation/json_annotation.dart';
import 'package:logpass_me/data/service/api/data/service_agreement_dto.dart';
import 'package:logpass_me/data/service/api/data/service_supported_scopes_dto.dart';

part 'client_dto.g.dart';

@JsonSerializable()
class ClientDTO {
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

  ClientDTO(
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
  );

  factory ClientDTO.fromJson(Map<String, dynamic> json) => _$ClientDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ClientDTOToJson(this);
}
