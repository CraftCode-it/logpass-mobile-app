import 'package:logpass_me/domain/common/clearable.dart';

abstract class PushNotificationsRepository implements Clearable {
  Future<void> initNotificationsServices();
}
