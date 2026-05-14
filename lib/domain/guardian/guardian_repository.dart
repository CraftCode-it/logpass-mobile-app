import 'package:logpass_me/domain/guardian/guardian.dart';

abstract class GuardianRepository {
  /// Returns guardians where current user is the minor (as_minor list).
  Future<List<Guardian>> getMyGuardians();

  /// Returns minors where current user is the guardian (as_guardian list).
  Future<List<Guardian>> getMyMinors();

  /// Guardian initiates pairing by scanning minor's QR code.
  Future<void> requestGuardian(String minorUserId, {String? relationshipType});

  /// Guardian confirms pairing request.
  Future<void> confirmGuardian(String guardianRequestId);

  /// Guardian rejects pairing request.
  Future<void> rejectGuardian(String guardianRequestId);

  /// Request authorization from guardian for a service action.
  Future<String> requestAuthorization({
    required String guardianId,
    required String serviceName,
    required String action,
  });

  /// Guardian approves authorization request.
  Future<void> approveAuthorization(String authRequestId);

  /// Guardian rejects authorization request.
  Future<void> rejectAuthorization(String authRequestId);

  /// Minor polls authorization request status.
  Future<String> pollAuthorizationStatus(String authRequestId);
}
