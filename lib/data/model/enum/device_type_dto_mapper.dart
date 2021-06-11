import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/bidirectional_data_mapper.dart';
import 'package:logpass_me/domain/model/device_type.dart';

@Injectable()
class DeviceTypeDTOMapper implements BidirectionalDataMapper<DeviceType, String> {
  static const Map<DeviceType, String> _typesMap = {
    DeviceType.pc: 'pc',
    DeviceType.mobile: 'mobile',
    DeviceType.tablet: 'tablet',
    DeviceType.unknown: 'unknown',
  };

  @override
  String from(DeviceType data) {
    return _typesMap[data] ?? (throw Exception('Missing type: $data'));
  }

  @override
  DeviceType to(String data) {
    return _typesMap.entries.firstWhere((element) => element.value == data).key;
  }
}
