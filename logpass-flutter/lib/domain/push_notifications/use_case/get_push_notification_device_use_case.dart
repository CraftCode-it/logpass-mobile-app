import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device_store.dart';

@Injectable()
class GetNotificationDeviceUseCase {
  final PushNotificationDeviceStore _pushNotificationDeviceStore;

  GetNotificationDeviceUseCase(this._pushNotificationDeviceStore);

  Future<PushNotificationDevice> call() async{
    final device = await _pushNotificationDeviceStore.load();

    if (device == null) throw Exception('Should register device before this operation.');

    return device;
  }
}