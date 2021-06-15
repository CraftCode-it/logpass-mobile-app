import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/data/oauth/dtos/denied_confirmation_dto.dart';
import 'package:logpass_me/domain/oauth/denied_confirmation.dart';

@injectable
class DeniedConfirmationDTOToDeniedConfirmationMapper extends DataMapper<DeniedConfirmationDTO, DeniedConfirmation> {
  @override
  DeniedConfirmation call(DeniedConfirmationDTO data) {
    return DeniedConfirmation(
      error: data.data.error,
      errorDescription: data.data.errorDescription,
      state: data.data.state,
      redirectUri: data.data.redirectUri,
    );
  }
}
