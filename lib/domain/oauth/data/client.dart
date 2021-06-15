import 'package:logpass_me/domain/model/grant_type.dart';
import 'package:logpass_me/domain/model/response_type.dart';
import 'package:logpass_me/domain/model/scope.dart';
import 'package:logpass_me/domain/service/data/service_agreement.dart';
import 'package:logpass_me/domain/service/data/service_supported_scopes.dart';

class Client {
  final String clientId;
  final String name;
  final String url;
  final String logo;
  final String email;
  final List<ServiceSupportedScopes> scopesSupported;
  final List<Scope> requiredScopes;
  final List<ResponseType> responseTypes;
  final List<GrantType> grantTypes;
  final List<ServiceAgreement> agreements;

  Client({
    required this.clientId,
    required this.name,
    required this.url,
    required this.logo,
    required this.email,
    required this.scopesSupported,
    required this.requiredScopes,
    required this.responseTypes,
    required this.grantTypes,
    required this.agreements,
  });
}
