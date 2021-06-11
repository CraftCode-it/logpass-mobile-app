import 'package:json_annotation/json_annotation.dart';

part 'response_pagination_metadata_dto.g.dart';

@JsonSerializable()
class ResponsePaginationMetadataDTO {
  final int totalCount;

  ResponsePaginationMetadataDTO(this.totalCount);

  Map<String, dynamic> toJson() => _$ResponsePaginationMetadataDTOToJson(this);

  factory ResponsePaginationMetadataDTO.fromJson(Map<String, dynamic> json) =>
      _$ResponsePaginationMetadataDTOFromJson(json);
}
