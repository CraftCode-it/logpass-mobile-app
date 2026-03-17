import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/bidirectional_data_mapper.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device_type.dart';

@injectable
class PushNotificationDeviceTypeDTOMapper extends BidirectionalDataMapper<PushTokenDeviceType, String> {
  static const Map<PushTokenDeviceType, String> _keyMap = {
    PushTokenDeviceType.android: 'android',
    PushTokenDeviceType.ios: 'apns',
  };

  @override
  String from(PushTokenDeviceType data) {
    return _keyMap[data] ?? (throw Exception('Unknown PushTokenDeviceType: ${data.toString()}'));
  }

  @override
  PushTokenDeviceType to(String data) {
    return _keyMap.entries.firstWhere((element) => element.value == data).key;
  }
}
