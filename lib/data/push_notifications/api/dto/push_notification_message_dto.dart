import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/data/push_notifications/api/dto/push_notification_data/push_notification_authorize_dto.dart';

part 'push_notification_message_dto.freezed.dart';
part 'push_notification_message_dto.g.dart';

@Freezed(unionKey: 'action', fallbackUnion: 'unknown')
class PushNotificationMessageDTO with _$PushNotificationMessageDTO {
  @FreezedUnionValue('oauth2_authorize')
  factory PushNotificationMessageDTO.authorize(PushNotificationAuthorizeDTO body) =
      _PushNotificationMessageDTOAuthorize;

  @FreezedUnionValue('unknown')
  factory PushNotificationMessageDTO.unknown(String action) = _PushNotificationMessageDTOUnknown;

  factory PushNotificationMessageDTO.fromJson(Map<String, dynamic> json) => _$PushNotificationMessageDTOFromJson(json);
}
