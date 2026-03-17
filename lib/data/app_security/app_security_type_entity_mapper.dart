import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/bidirectional_data_mapper.dart';
import 'package:logpass_me/domain/app_security/app_security_type.dart';

@Injectable()
class AppSecurityTypeEntityMapper implements BidirectionalDataMapper<AppSecurityType, String> {
  static const Map<AppSecurityType, String> _map = {
    AppSecurityType.none: 'none',
    AppSecurityType.code: 'code',
    AppSecurityType.biometric: 'biometric',
  };

  @override
  String from(AppSecurityType data) {
    return _map[data]!;
  }

  @override
  AppSecurityType to(String data) {
    return _map.entries.firstWhere((element) => element.value == data).key;
  }
}
