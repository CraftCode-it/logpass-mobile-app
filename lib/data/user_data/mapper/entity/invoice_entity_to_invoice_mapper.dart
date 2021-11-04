import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/user_data/entity/invoice_entity.dart';
import 'package:logpass_me/data/user_data/mapper/entity/hive_entity_mapper.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';

@injectable
class InvoiceEntityToInvoiceMapper implements HiveEntityMapper<InvoiceEntity, InvoiceData> {
  @override
  InvoiceData from(InvoiceEntity dto) {
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
  InvoiceEntity to(InvoiceData invoice) {
    return InvoiceEntity(
      name: invoice.name,
      surname: invoice.surname,
      street: invoice.street,
      buildingNumber: invoice.buildingNumber,
      postCode: invoice.postCode,
      city: invoice.city,
      isDefault: invoice.isDefault,
      uuid: invoice.uuid,
      taxId: invoice.taxId,
      apartmentNumber: invoice.apartmentNumber,
    );
  }
}
