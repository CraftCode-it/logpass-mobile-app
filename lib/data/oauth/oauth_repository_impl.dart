import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/networking/error/dio_error_resolver.dart';
import 'package:logpass_me/data/oauth/api/oauth_api_data_source.dart';
import 'package:logpass_me/data/oauth/dtos/user_assignment_dto.dart';
import 'package:logpass_me/data/oauth/mappers/denied_confirmation_dto_to_denied_confirmation_mapper.dart';
import 'package:logpass_me/data/oauth/mappers/oauth_application_dto_to_oauth_application_mapper.dart';
import 'package:logpass_me/domain/oauth/denied_confirmation.dart';
import 'package:logpass_me/domain/oauth/oauth_application.dart';
import 'package:logpass_me/domain/oauth/oauth_repository.dart';

@Singleton(as: OAuthRepository)
class OAuthRepositoryImpl implements OAuthRepository {
  final OAuthApiDataSource _oAuthApiDataSource;
  final OAuthApplicationDTOToOAuthApplicationMapper _dtoToOAuthApplicationMapper;
  final DeniedConfirmationDTOToDeniedConfirmationMapper _deniedConfirmationMapper;

  OAuthRepositoryImpl(
    this._oAuthApiDataSource,
    this._dtoToOAuthApplicationMapper,
    this._deniedConfirmationMapper,
  );

  @override
  Future<OAuthApplication> getOAuthApplicationDetails(String authorizationAttemptId) async {
    final responseDTO = await callWithDioErrorResolver(
      () => _oAuthApiDataSource.getOAuthApplicationDetails(authorizationAttemptId),
    );
    final oAuthApplication = _dtoToOAuthApplicationMapper(responseDTO);
    return oAuthApplication;
  }

  @override
  Future<void> assignToOAuthAttempt(String authorizationAttemptId, String phoneNumber) async {
    final requestBody = UserAssignmentDTO(phoneNumber, false);

    await callWithDioErrorResolver(
      () => _oAuthApiDataSource.assignToOAuthAttempt(authorizationAttemptId, requestBody),
    );
  }

  @override
  Future<DeniedConfirmation> denyOAuthAttempt(String authorizationAttemptId) async {
    final responseDTO = await callWithDioErrorResolver(
      () => _oAuthApiDataSource.denyOAuthAttempt(authorizationAttemptId),
    );
    final deniedConfirmation = _deniedConfirmationMapper(responseDTO);
    return deniedConfirmation;
  }
}
