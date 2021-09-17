abstract class AgreementRepository {
  Future<void> confirmAgreement(String agreementId);

  Future<void> revokeAgreement(String agreementId);

  Future<void> revokeAll(String clientId);
}
