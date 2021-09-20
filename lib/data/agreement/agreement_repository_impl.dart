import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/agreement/api/agreement_api_data_source.dart';
import 'package:logpass_me/data/networking/error/dio_error_resolver.dart';
import 'package:logpass_me/domain/agreement/agreement_repository.dart';

@LazySingleton(as: AgreementRepository)
class AgreementRepositoryImpl implements AgreementRepository {
  final AgreementApiDataSource _agreementApiDataSource;

  AgreementRepositoryImpl(this._agreementApiDataSource);

  @override
  Future<void> confirmAgreement(String agreementId) async {
    await callWithDioErrorResolver(
      () => _agreementApiDataSource.confirmAgreement(agreementId),
    );
  }

  @override
  Future<void> revokeAgreement(String agreementId) async {
    await callWithDioErrorResolver(
      () => _agreementApiDataSource.revokeAgreement(agreementId),
    );
  }

  @override
  Future<void> revokeAll(String clientId) async {
    await callWithDioErrorResolver(
            () => _agreementApiDataSource.revokeAll(clientId),
    );
  }
}
