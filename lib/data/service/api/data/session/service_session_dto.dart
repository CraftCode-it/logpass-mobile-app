import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logpass_me/data/common/bidirectional_data_mapper.dart';
import 'package:logpass_me/data/model/date_time_dto_mapper.dart';
import 'package:logpass_me/data/model/enum/device_type_dto_mapper.dart';
import 'package:logpass_me/data/service/api/data/service_supported_scopes_dto.dart';
import 'package:logpass_me/domain/service/data/session/service_session.dart';

part 'service_session_dto.g.dart';

@JsonSerializable()
class ServiceSessionDTO {
  final int id;
  final String user;
  final bool isActive;
  final String expiresAt;
  final String createdAt;
  final String? ipAddress;
  final String country;
  final String city;
  final String deviceType;
  final String deviceName;
  final String operatingSystem;
  final String browser;
  final List<ServiceSupportedScopesDTO> scopes;

  ServiceSessionDTO(
    this.id,
    this.user,
    this.isActive,
    this.expiresAt,
    this.createdAt,
    this.ipAddress,
    this.country,
    this.city,
    this.deviceType,
    this.deviceName,
    this.operatingSystem,
    this.browser,
    this.scopes,
  );

  factory ServiceSessionDTO.fromJson(Map<String, dynamic> json) => _$ServiceSessionDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceSessionDTOToJson(this);
}

@Injectable()
class ServiceSessionDTOMapper implements BidirectionalDataMapper<ServiceSession, ServiceSessionDTO> {
  final DateTimeDTOMapper _dateTimeDTOMapper;
  final DeviceTypeDTOMapper _deviceTypeDTOMapper;
  final ServiceSupportedScopesDTOMapper _serviceSupportedScopesDTOMapper;

  ServiceSessionDTOMapper(
    this._dateTimeDTOMapper,
    this._deviceTypeDTOMapper,
    this._serviceSupportedScopesDTOMapper,
  );

  @override
  ServiceSessionDTO from(ServiceSession data) {
    return ServiceSessionDTO(
      data.id,
      data.user,
      data.isActive,
      _dateTimeDTOMapper.from(data.expiresAt),
      _dateTimeDTOMapper.from(data.createdAt),
      data.ipAddress,
      data.country,
      data.city,
      _deviceTypeDTOMapper.from(data.deviceType),
      data.deviceName,
      data.operatingSystem,
      data.browser,
      data.scopes.map(_serviceSupportedScopesDTOMapper.from).toList(),
    );
  }

  @override
  ServiceSession to(ServiceSessionDTO data) {
    return ServiceSession(
      id: data.id,
      user: data.user,
      isActive: data.isActive,
      expiresAt: _dateTimeDTOMapper.to(data.expiresAt),
      createdAt: _dateTimeDTOMapper.to(data.createdAt),
      country: data.country,
      city: data.city,
      deviceType: _deviceTypeDTOMapper.to(data.deviceType),
      deviceName: data.deviceName,
      operatingSystem: data.operatingSystem,
      browser: data.browser,
      scopes: data.scopes.map(_serviceSupportedScopesDTOMapper.to).toList(),
    );
  }
}
