import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_notification_authorize_dto.g.dart';

@JsonSerializable()
class PushNotificationAuthorizeDTO {
  final String id;

  PushNotificationAuthorizeDTO(this.id);

  Map<String, dynamic> toJson() => _$PushNotificationAuthorizeDTOToJson(this);

  factory PushNotificationAuthorizeDTO.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationAuthorizeDTOFromJson(json);
}
