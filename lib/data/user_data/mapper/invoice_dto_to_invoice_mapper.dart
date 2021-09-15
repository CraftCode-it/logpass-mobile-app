import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/user_data/dto/invoice_dto.dart';
import 'package:logpass_me/data/user_data/mapper/hive_dto_mapper.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';

@injectable
class InvoiceDtoToInvoiceMapper implements HiveDtoMapper<InvoiceDto, InvoiceData> {
  @override
  InvoiceData from(InvoiceDto dto) {
    return InvoiceData(
      name: dto.name,
      street: dto.street,
      buildingNumber: dto.buildingNumber,
      apartmentNumber: dto.apartmentNumber,
      taxId: dto.taxId,
      postCode: dto.postCode,
      city: dto.city,
      uuid: dto.uuid,
      isDefault: dto.isDefault,
      surname: dto.surname,
    );
  }

  @override
  InvoiceDto to(InvoiceData invoice) {
    return InvoiceDto(
      name: invoice.name,
      surname: invoice.surname,
      street: invoice.street,
      buildingNumber: invoice.buildingNumber,
      postCode: invoice.postCode,
      city: invoice.city,
      isDefault: invoice.isDefault,
      uuid: invoice.uuid,
    );
  }
}
