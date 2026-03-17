import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/bidirectional_data_mapper.dart';
import 'package:logpass_me/domain/model/response_type.dart';

@Injectable()
class ResponseTypeDTOMapper implements BidirectionalDataMapper<ResponseType, String> {
  static const Map<ResponseType, String> _typesMap = {
    ResponseType.code: 'code',
    ResponseType.token: 'token',
  };

  @override
  String from(ResponseType data) {
    return _typesMap[data] ?? (throw Exception('Missing type: $data'));
  }

  @override
  ResponseType to(String data) {
    return _typesMap.entries.firstWhere((element) => element.value == data).key;
  }
}
