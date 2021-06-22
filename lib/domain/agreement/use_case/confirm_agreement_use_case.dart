import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/agreement/agreement_repository.dart';
import 'package:logpass_me/domain/service/data/service_agreement.dart';

@injectable
class ConfirmAgreementUseCase {
  final AgreementRepository _agreementRepository;

  ConfirmAgreementUseCase(this._agreementRepository);

  Future<void> call(ServiceAgreement agreement) => _agreementRepository.confirmAgreement(agreement.id);
}
