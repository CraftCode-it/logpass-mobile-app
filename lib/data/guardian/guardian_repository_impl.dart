import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/wallet/wallet_api_data_source.dart';
import 'package:logpass_me/domain/guardian/guardian.dart';
import 'package:logpass_me/domain/guardian/guardian_repository.dart';

@Injectable(as: GuardianRepository)
class GuardianRepositoryImpl implements GuardianRepository {
  final WalletApiDataSource _api;

  GuardianRepositoryImpl(this._api);

  @override
  Future<List<Guardian>> getMyGuardians() async {
    final resp = await _api.getUserGuardians();
    final list = resp['as_minor'] as List? ?? [];
    return list.map((e) => Guardian.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<Guardian>> getMyMinors() async {
    final resp = await _api.getUserGuardians();
    final list = resp['as_guardian'] as List? ?? [];
    return list.map((e) => Guardian.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> requestGuardian(String guardianUserId, {String? relationshipType}) async {
    await _api.requestGuardian(guardianUserId: guardianUserId, relationshipType: relationshipType);
  }

  @override
  Future<void> confirmGuardian(String guardianRequestId) async {
    await _api.confirmGuardian(guardianRequestId);
  }

  @override
  Future<void> rejectGuardian(String guardianRequestId) async {
    await _api.rejectGuardian(guardianRequestId);
  }

  @override
  Future<String> requestAuthorization({
    required String guardianId,
    required String serviceName,
    required String action,
  }) async {
    final resp = await _api.requestAuthorization(
      guardianId: guardianId,
      serviceName: serviceName,
      action: action,
    );
    return resp['id'] as String? ?? resp['auth_request_id'] as String? ?? '';
  }

  @override
  Future<void> approveAuthorization(String authRequestId) async {
    await _api.approveAuthorization(authRequestId);
  }

  @override
  Future<void> rejectAuthorization(String authRequestId) async {
    await _api.rejectAuthorization(authRequestId);
  }

  @override
  Future<String> pollAuthorizationStatus(String authRequestId) async {
    final resp = await _api.pollAuthorization(authRequestId);
    return resp['status'] as String? ?? 'pending';
  }
}
