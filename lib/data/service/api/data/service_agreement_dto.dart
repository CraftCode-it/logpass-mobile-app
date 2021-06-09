import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logpass_me/data/common/bidirectional_data_mapper.dart';
import 'package:logpass_me/data/model/enum/agreement_type_dto_mapper.dart';
import 'package:logpass_me/data/model/enum/scope_dto_mapper.dart';
import 'package:logpass_me/domain/service/data/service_agreement.dart';

part 'service_agreement_dto.g.dart';

@JsonSerializable()
class ServiceAgreementDTO {
  final int id;
  final String type;
  final String name;
  final String url;
  final String checksum;
  final bool isRequired;
  final bool isAccepted;
  final String? scope;
  final String createdAt;
  final String updatedAt;

  ServiceAgreementDTO(
    this.id,
    this.type,
    this.name,
    this.url,
    this.checksum,
    this.isRequired,
    this.isAccepted,
    this.scope,
    this.createdAt,
    this.updatedAt,
  );

  factory ServiceAgreementDTO.fromJson(Map<String, dynamic> json) => _$ServiceAgreementDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceAgreementDTOToJson(this);
}

@Injectable()
class ServiceAgreementDTOMapper implements BidirectionalDataMapper<ServiceAgreement, ServiceAgreementDTO> {
  final AgreementTypeDTOMapper _agreementTypeDTOMapper;
  final ScopeDTOMapper _scopeDTOMapper;

  ServiceAgreementDTOMapper(this._agreementTypeDTOMapper, this._scopeDTOMapper);

  @override
  ServiceAgreementDTO from(ServiceAgreement data) {
    return ServiceAgreementDTO(
      data.id,
      _agreementTypeDTOMapper.from(data.type),
      data.name,
      data.url,
      data.checksum,
      data.isRequired,
      data.isAccepted,
      data.scope != null ? _scopeDTOMapper.from(data.scope!) : null,
      data.createdAt,
      data.updatedAt,
    );
  }

  @override
  ServiceAgreement to(ServiceAgreementDTO data) {
    return ServiceAgreement(
      id: data.id,
      type: _agreementTypeDTOMapper.to(data.type),
      name: data.name,
      url: data.url,
      checksum: data.checksum,
      isRequired: data.isRequired,
      isAccepted: data.isAccepted,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      scope: data.scope != null ? _scopeDTOMapper.to(data.scope!) : null,
    );
  }
}
