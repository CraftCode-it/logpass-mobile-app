import 'package:freezed_annotation/freezed_annotation.dart';

part 'backup_entry_dto.g.dart';

@JsonSerializable()
class BackupEntryDto {
  final String key;
  final String data;

  BackupEntryDto(this.key, this.data);

  Map<String, dynamic> toJson() => _$BackupEntryDtoToJson(this);

  factory BackupEntryDto.fromJson(Map<String, dynamic> json) => _$BackupEntryDtoFromJson(json);
}
