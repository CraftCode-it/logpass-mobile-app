abstract class AgreementRepository {
  Future<void> confirmAgreement(String agreementId);

  Future<void> revokeAgreement(String agreementId);
}
