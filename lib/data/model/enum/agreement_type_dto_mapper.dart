import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/bidirectional_data_mapper.dart';
import 'package:logpass_me/domain/model/agreement_type.dart';

@Injectable()
class AgreementTypeDTOMapper implements BidirectionalDataMapper<AgreementType, String> {
  static const Map<AgreementType, String> _typesMap = {
    AgreementType.marketing: 'marketing',
    AgreementType.termsOfService: 'terms_of_service',
  };

  @override
  String from(AgreementType data) {
    return _typesMap[data] ?? (throw Exception('Missing type: $data'));
  }

  @override
  AgreementType to(String data) {
    return _typesMap.entries.firstWhere((element) => element.value == data).key;
  }
}
