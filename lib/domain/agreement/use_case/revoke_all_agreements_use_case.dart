import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/agreement/agreement_repository.dart';
import 'package:logpass_me/domain/service/data/service_agreement.dart';

@injectable
class RevokeAllAgreementsUseCase {
  final AgreementRepository _agreementRepository;

  RevokeAllAgreementsUseCase(this._agreementRepository);

  Future<void> call(String clientId) => _agreementRepository.revokeAll(clientId);
}
