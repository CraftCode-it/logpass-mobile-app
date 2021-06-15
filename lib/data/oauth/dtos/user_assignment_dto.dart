import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_assignment_dto.g.dart';

@JsonSerializable()
class UserAssignmentDTO {
  final String user;
  final bool sendPushNotification;

  UserAssignmentDTO(this.user, this.sendPushNotification);

  Map<String, dynamic> toJson() => _$UserAssignmentDTOToJson(this);
}
