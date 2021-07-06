import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_data/push_notification_authorize_data.dart';

part 'push_notification_message.freezed.dart';

@freezed
class PushNotificationMessage with _$PushNotificationMessage {
  factory PushNotificationMessage.authorize(PushNotificationAuthorizeData data) = _PushNotificationMessageAuthorize;

  factory PushNotificationMessage.unknown(String action) = _PushNotificationMessageUnknown;
}
