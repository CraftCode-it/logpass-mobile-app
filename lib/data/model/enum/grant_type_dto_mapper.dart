import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/bidirectional_data_mapper.dart';
import 'package:logpass_me/domain/model/grant_type.dart';

@Injectable()
class GrantTypeDTOMapper implements BidirectionalDataMapper<GrantType, String> {
  static const Map<GrantType, String> _typesMap = {
    GrantType.authorizationCode: 'authorization_code',
    GrantType.refreshToken: 'refresh_token',
  };

  @override
  String from(GrantType data) {
    return _typesMap[data] ?? (throw Exception('Missing type: $data'));
  }

  @override
  GrantType to(String data) {
    return _typesMap.entries.firstWhere((element) => element.value == data).key;
  }
}
