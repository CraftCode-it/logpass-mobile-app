import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logpass_me/data/common/bidirectional_data_mapper.dart';
import 'package:logpass_me/domain/service/data/service_tokens.dart';

part 'service_tokens_dto.g.dart';

@JsonSerializable()
class ServiceTokensDTO {
  final int totalCount;
  final int activeCount;

  ServiceTokensDTO(this.totalCount, this.activeCount);

  factory ServiceTokensDTO.fromJson(Map<String, dynamic> json) => _$ServiceTokensDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceTokensDTOToJson(this);
}

@Injectable()
class ServiceTokensDTOMapper implements BidirectionalDataMapper<ServiceTokens, ServiceTokensDTO> {
  @override
  ServiceTokensDTO from(ServiceTokens data) {
    return ServiceTokensDTO(
      data.totalCount,
      data.activeCount,
    );
  }

  @override
  ServiceTokens to(ServiceTokensDTO data) {
    return ServiceTokens(
      totalCount: data.totalCount,
      activeCount: data.activeCount,
    );
  }
}
