import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/data/oauth/dtos/approve_attempt_dto.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';

@injectable
class ApproveAttemptInvoiceInfoDTOMapper extends DataMapper<InvoiceData?, ApproveAttemptInvoiceInfoDTO?> {
  @override
  ApproveAttemptInvoiceInfoDTO? call(InvoiceData? data) {
    if(data == null) {
      return null;
    }

    return ApproveAttemptInvoiceInfoDTO(
        data.taxId,
        data.surname,
        data.street,
        data.buildingNumber,
        data.apartmentNumber,
        data.postCode,
        data.street,
    );
  }

}