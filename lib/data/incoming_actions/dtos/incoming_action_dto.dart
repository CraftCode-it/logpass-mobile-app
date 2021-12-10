import 'package:freezed_annotation/freezed_annotation.dart';

part 'incoming_action_dto.g.dart';

@JsonSerializable()
class IncomingActionDTO {
  final String type;
  final IncomingActionDataDTO data;

  IncomingActionDTO(this.type, this.data);

  Map<String, dynamic> toJson() => _$IncomingActionDTOToJson(this);

  factory IncomingActionDTO.fromJson(Map<String, dynamic> json) => _$IncomingActionDTOFromJson(json);
}

@JsonSerializable()
class IncomingActionDataDTO {
  final String title;
  final String body;
  final IncomingActionDataFieldsDTO dataFields;
  final String imageUrl;
  final int ttl;
  final String collapseKey;
  final String createdAt;

  IncomingActionDataDTO(this.title, this.body, this.dataFields, this.imageUrl,
      this.ttl, this.collapseKey, this.createdAt);

  Map<String, dynamic> toJson() => _$IncomingActionDataDTOToJson(this);

  factory IncomingActionDataDTO.fromJson(Map<String, dynamic> json) =>
      _$IncomingActionDataDTOFromJson(json);
}

@JsonSerializable()
class IncomingActionDataFieldsDTO {
  final String action;
  final String? link;
  final String? sendAttemptId;
  final String? body;

  IncomingActionDataFieldsDTO(this.action, this.link, this.sendAttemptId, this.body);

  Map<String, dynamic> toJson() => _$IncomingActionDataFieldsDTOToJson(this);

  factory IncomingActionDataFieldsDTO.fromJson(Map<String, dynamic> json) =>
      _$IncomingActionDataFieldsDTOFromJson(json);
}