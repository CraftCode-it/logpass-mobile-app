import 'package:injectable/injectable.dart' hide Scope;
import 'package:logpass_me/data/common/bidirectional_data_mapper.dart';
import 'package:logpass_me/domain/model/scope.dart';

@Injectable()
class ScopeDTOMapper implements BidirectionalDataMapper<Scope, String> {
  static const Map<Scope, String> _typesMap = {
    Scope.openId: 'openid',
    Scope.organization: 'organization',
    Scope.profile: 'profile',
    Scope.email: 'email',
    Scope.phoneNumber: 'phone_number',
    Scope.address: 'address',
    Scope.invoice: 'invoice',
    Scope.agreementMarketing: 'agreements:marketing',
    Scope.verificationBiometric: 'verification:biometric',
  };

  @override
  String from(Scope data) {
    return _typesMap[data] ?? (throw Exception('Missing type: $data'));
  }

  @override
  Scope to(String data) {
    return _typesMap.entries.firstWhere((element) => element.value == data).key;
  }
}
