import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/agreement/agreement_repository.dart';
import 'package:logpass_me/domain/service/data/service_agreement.dart';

@injectable
class RevokeAgreementUseCase {
  final AgreementRepository _agreementRepository;

  RevokeAgreementUseCase(this._agreementRepository);

  Future<void> call(ServiceAgreement agreement) => _agreementRepository.revokeAgreement(agreement.id);
}
