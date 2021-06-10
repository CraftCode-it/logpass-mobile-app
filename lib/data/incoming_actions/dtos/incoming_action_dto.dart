import 'package:freezed_annotation/freezed_annotation.dart';

part 'incoming_action_dto.g.dart';

@JsonSerializable()
class IncomingActionDTO {
  final String link;

  IncomingActionDTO(this.link);

  Map<String, dynamic> toJson() => _$IncomingActionDTOToJson(this);

  factory IncomingActionDTO.fromJson(Map<String, dynamic> json) => _$IncomingActionDTOFromJson(json);
}
