import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/data/model/enum/scope_dto_mapper.dart';
import 'package:logpass_me/data/oauth/dtos/oauth_application_dto.dart';
import 'package:logpass_me/data/service/api/data/service_dto.dart';
import 'package:logpass_me/domain/oauth/data/oauth_application.dart';

@injectable
class OAuthApplicationDTOToOAuthApplicationMapper implements DataMapper<OAuthApplicationDTO, OAuthApplication> {
  final ScopeDTOMapper _scopeDTOMapper;
  final ServiceDTOMapper _serviceDTOMapper;

  OAuthApplicationDTOToOAuthApplicationMapper(this._scopeDTOMapper, this._serviceDTOMapper);

  @override
  OAuthApplication call(OAuthApplicationDTO data) {
    return OAuthApplication(
      id: data.data.id,
      user: data.data.user ?? '',
      deviceType: data.data.deviceType,
      deviceName: data.data.deviceName,
      operatingSystem: data.data.operatingSystem,
      browser: data.data.browser,
      ipAddress: data.data.ipAddress,
      city: data.data.city,
      country: data.data.country,
      isRemote: data.data.isRemote,
      scopesRequested: data.data.scopesRequested.map(_scopeDTOMapper.to).toList(),
      service: _serviceDTOMapper.to(data.data.service),
      trustLevel: data.data.trustLevel,
    );
  }
}
