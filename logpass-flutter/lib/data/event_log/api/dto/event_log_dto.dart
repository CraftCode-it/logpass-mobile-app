import 'package:json_annotation/json_annotation.dart';
import 'package:logpass_me/data/event_log/api/dto/extra_data_dto.dart';

part 'event_log_dto.g.dart';

@JsonSerializable()
class EventLogDTO {
  final String id;
  final int version;
  final String type;
  final String correlationId;
  final String reportedAt;
  final String createdAt;
  final ExtraDataDTO extraData;

  EventLogDTO(this.id, this.version, this.type, this.correlationId,
      this.reportedAt, this.createdAt, this.extraData);

  factory EventLogDTO.fromJson(Map<String, dynamic> json) =>
      _$EventLogDTOFromJson(json);

  Map<String, dynamic> toJson() => _$EventLogDTOToJson(this);
}