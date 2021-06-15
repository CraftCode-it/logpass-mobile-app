import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/data/oauth/dtos/approved_confirmation_dto.dart';
import 'package:logpass_me/domain/oauth/data/approved_confirmation.dart';

@injectable
class ApprovedConfirmationDTOToApprovedConfirmationMapper
    extends DataMapper<ApprovedConfirmationDTO, ApprovedConfirmation> {
  @override
  ApprovedConfirmation call(ApprovedConfirmationDTO data) {
    return ApprovedConfirmation(
      code: data.data.code,
      state: data.data.state,
      redirectUri: data.data.redirectUri,
    );
  }
}
