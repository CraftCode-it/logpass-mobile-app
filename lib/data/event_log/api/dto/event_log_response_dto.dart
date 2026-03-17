import 'package:json_annotation/json_annotation.dart';
import 'package:logpass_me/data/event_log/api/dto/event_log_dto.dart';
import 'package:logpass_me/data/networking/model/response_pagination_metadata_dto.dart';

part 'event_log_response_dto.g.dart';

@JsonSerializable()
class EventLogResponseDTO {
  @JsonKey(name: '_meta')
  final ResponsePaginationMetadataDTO metadata;
  final List<EventLogDTO> data;

  EventLogResponseDTO(this.metadata, this.data);

  factory EventLogResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$EventLogResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$EventLogResponseDTOToJson(this);
}