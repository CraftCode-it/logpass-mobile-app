import 'package:json_annotation/json_annotation.dart';

part 'response_metadata_dto.g.dart';

@JsonSerializable()
class ResponseMetadataDTO {
  final int totalCount;

  ResponseMetadataDTO(this.totalCount);

  Map<String, dynamic> toJson() => _$ResponseMetadataDTOToJson(this);

  factory ResponseMetadataDTO.fromJson(Map<String, dynamic> json) => _$ResponseMetadataDTOFromJson(json);
}
