import 'package:json_annotation/json_annotation.dart';
import 'package:logpass_me/data/common/serializable_dto.dart';

part 'adress_dto.g.dart';

@JsonSerializable()
class AddressDto implements SerializableDto<AddressDto> {
  AddressDto();

  @override
  Map<String, dynamic> toJson() => _$AddressDtoToJson(this);

  factory AddressDto.fromJson(Map<String, dynamic> json) => _$AddressDtoFromJson(json);

  @override
  AddressDto fromJson(Map<String, dynamic> data) {
    return AddressDto.fromJson(data);
  }
}
