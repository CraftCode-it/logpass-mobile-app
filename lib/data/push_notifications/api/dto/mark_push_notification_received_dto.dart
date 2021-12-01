import 'package:json_annotation/json_annotation.dart';

part 'mark_push_notification_received_dto.g.dart';

@JsonSerializable()
class MarkPushNotificationReceivedDTO {

  final String deliveredAt;

  MarkPushNotificationReceivedDTO(this.deliveredAt);

  Map<String, dynamic> toJson() => _$MarkPushNotificationReceivedDTOToJson(this);
}