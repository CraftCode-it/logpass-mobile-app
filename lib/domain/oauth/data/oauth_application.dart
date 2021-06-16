import 'package:logpass_me/domain/model/scope.dart';
import 'package:logpass_me/domain/oauth/data/client.dart';

class OAuthApplication {
  final String id;
  final String user;
  final String deviceType;
  final String deviceName;
  final String operatingSystem;
  final String browser;
  final String ipAddress;
  final String city;
  final String country;
  final bool isRemote;
  final List<Scope> scopesRequested;
  final Client client;

  OAuthApplication({
    required this.id,
    required this.user,
    required this.deviceType,
    required this.deviceName,
    required this.operatingSystem,
    required this.browser,
    required this.ipAddress,
    required this.city,
    required this.country,
    required this.isRemote,
    required this.scopesRequested,
    required this.client,
  });
}
