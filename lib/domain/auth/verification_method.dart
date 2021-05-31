import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/bidirectional_data_mapper.dart';

enum VerificationMethod { otpCode, signature }

@Injectable()
class VerificationMethodMapper implements BidirectionalDataMapper<VerificationMethod, String> {
  static const Map<VerificationMethod, String> _valueMap = {
    VerificationMethod.otpCode: 'otp_code',
    VerificationMethod.signature: 'signature',
  };

  @override
  String from(VerificationMethod data) {
    final mapped = _valueMap[data];

    if (mapped == null) {
      throw UnimplementedError('Missing in mapper implementation: $data');
    }

    return mapped;
  }

  @override
  VerificationMethod to(String data) {
    return _valueMap.entries.firstWhere((element) => element.value == data).key;
  }
}
