import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/data/oauth/dtos/approve_attempt_dto.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';

@injectable
class ApproveAttemptAddressInfoDTOMapper extends DataMapper<Address?, ApproveAttemptAddressInfoDTO?> {
  @override
  ApproveAttemptAddressInfoDTO? call(Address? data) {
    if(data == null) {
      return null;
    }

    return ApproveAttemptAddressInfoDTO(
        data.name,
        data.street,
        data.buildingNumber,
        data.apartmentNumber,
        data.postCode,
        data.city,
        data.country,
    );
  }

}