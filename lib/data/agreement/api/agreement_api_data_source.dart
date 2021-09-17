import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/networking/log_pass_dio.dart';
import 'package:retrofit/http.dart';

part 'agreement_api_data_source.g.dart';

@LazySingleton()
@RestApi()
abstract class AgreementApiDataSource {
  @factoryMethod
  factory AgreementApiDataSource(LogPassDio dio) = _AgreementApiDataSource;

  @POST('/agreements/{agreementId}/consents/')
  Future<void> confirmAgreement(@Path('agreementId') String agreementId);

  @DELETE('/agreements/{agreementId}/consents/')
  Future<void> revokeAgreement(@Path('agreementId') String agreementId);

  @DELETE('/users/self/authorized-applications/{clientId}?has_revoke_agreements=True')
  Future<void> revokeAll(@Path('clientId') String clientId);
}
