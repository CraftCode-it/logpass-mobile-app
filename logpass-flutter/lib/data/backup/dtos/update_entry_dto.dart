import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/data/backup/dtos/backup_entry_dto.dart';

part 'update_entry_dto.g.dart';

@JsonSerializable()
class UpdateEntryDto extends BackupEntryDto {
  final String lastChecksum;

  UpdateEntryDto(String key, String data, this.lastChecksum) : super(key, data);

  Map<String, dynamic> toJson() => _$UpdateEntryDtoToJson(this);

  factory UpdateEntryDto.fromJson(Map<String, dynamic> json) => _$UpdateEntryDtoFromJson(json);
}
