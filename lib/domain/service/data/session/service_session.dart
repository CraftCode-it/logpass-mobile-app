import 'package:logpass_me/domain/model/device_type.dart';
import 'package:logpass_me/domain/model/scope.dart';
import 'package:logpass_me/domain/service/data/service_supported_scopes.dart';

class ServiceSession {
  final int id;
  final String user;
  final bool isActive;
  final DateTime expiresAt;
  final DateTime createdAt;
  final String? ipAddress;
  final String country;
  final String city;
  final DeviceType deviceType;
  final String deviceName;
  final String operatingSystem;
  final String browser;
  final List<ServiceSupportedScopes> scopes;

  ServiceSession({
    required this.id,
    required this.user,
    required this.isActive,
    required this.expiresAt,
    required this.createdAt,
    required this.country,
    required this.city,
    required this.deviceType,
    required this.deviceName,
    required this.operatingSystem,
    required this.browser,
    required this.scopes,
    this.ipAddress,
  });
}
