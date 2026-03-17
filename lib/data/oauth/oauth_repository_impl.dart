import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/model/enum/scope_dto_mapper.dart';
import 'package:logpass_me/data/networking/error/dio_error_resolver.dart';
import 'package:logpass_me/data/oauth/api/oauth_api_data_source.dart';
import 'package:logpass_me/data/oauth/dtos/approve_attempt_dto.dart';
import 'package:logpass_me/data/oauth/dtos/user_assignment_dto.dart';
import 'package:logpass_me/data/oauth/mappers/approve_attempt_address_info_dto_mapper.dart';
import 'package:logpass_me/data/oauth/mappers/approve_attempt_invoice_info_dto_mapper.dart';
import 'package:logpass_me/data/oauth/mappers/approved_confirmation_dto_to_approved_confirmation_mapper.dart';
import 'package:logpass_me/data/oauth/mappers/denied_confirmation_dto_to_denied_confirmation_mapper.dart';
import 'package:logpass_me/data/oauth/mappers/oauth_application_dto_to_oauth_application_mapper.dart';
import 'package:logpass_me/domain/oauth/data/approve_attempt_args.dart';
import 'package:logpass_me/domain/oauth/data/approved_confirmation.dart';
import 'package:logpass_me/domain/oauth/data/denied_confirmation.dart';
import 'package:logpass_me/domain/oauth/data/oauth_application.dart';
import 'package:logpass_me/domain/oauth/oauth_repository.dart';

@Singleton(as: OAuthRepository)
class OAuthRepositoryImpl implements OAuthRepository {
  final OAuthApiDataSource _oAuthApiDataSource;
  final OAuthApplicationDTOToOAuthApplicationMapper _dtoToOAuthApplicationMapper;
  final DeniedConfirmationDTOToDeniedConfirmationMapper _deniedConfirmationMapper;
  final ApprovedConfirmationDTOToApprovedConfirmationMapper _approvedConfirmationMapper;
  final ApproveAttemptAddressInfoDTOMapper _addressInfoDTOMapper;
  final ApproveAttemptInvoiceInfoDTOMapper _invoiceInfoDTOMapper;
  final ScopeDTOMapper _scopeDTOMapper;

  OAuthRepositoryImpl(
    this._oAuthApiDataSource,
    this._dtoToOAuthApplicationMapper,
    this._deniedConfirmationMapper,
    this._approvedConfirmationMapper,
    this._addressInfoDTOMapper,
    this._invoiceInfoDTOMapper,
    this._scopeDTOMapper,
  );

  @override
  Future<OAuthApplication> initializeUserAuth(Map<String, String> authorizationData) async {
    final responseDTO = await callWithDioErrorResolver(
      () => _oAuthApiDataSource.initializeUserAuth(authorizationData),
    );
    final oAuthApplication = _dtoToOAuthApplicationMapper(responseDTO);
    return oAuthApplication;
  }

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

  @override
  Future<ApprovedConfirmation> approveOAuthAttempt(
    String authorizationAttemptId,
    String tokenSub,
    ApproveAttemptArgs args,
  ) async {

    final mappedScopes = args.extraScopes.map(_scopeDTOMapper.from).toList();
    final userInfoDTO = ApproveAttemptUserInfoDTO(
        tokenSub,
        args.email,
        args.emailVerified,
        args.phoneNumber,
        args.phoneNumberVerified,
        args.name,
        args.surname,
        args.locale,
        _addressInfoDTOMapper(args.address),
        _invoiceInfoDTOMapper(args.invoice)
    );
    final requestBody = ApproveAttemptDTO(userInfoDTO, mappedScopes);

    final responseDTO = await callWithDioErrorResolver(
      () => _oAuthApiDataSource.approveOAuthAttempt(authorizationAttemptId, requestBody),
    );
    final approvedConfirmation = _approvedConfirmationMapper(responseDTO);
    return approvedConfirmation;
  }
}
