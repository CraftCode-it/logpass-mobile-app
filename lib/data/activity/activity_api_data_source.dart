import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/wallet/wallet_api_data_source.dart';
import 'package:logpass_me/domain/activity/service_activity.dart';

@injectable
class ActivityApiDataSource {
  final WalletApiDataSource _api;

  ActivityApiDataSource(this._api);

  Future<List<ServiceSummary>> getServices() async {
    final list = await _api.getUserServices();
    return list.map(ServiceSummary.fromJson).toList();
  }

  Future<List<ServiceActivity>> getActivity({String? service, int offset = 0, int limit = 20}) async {
    final list = await _api.getUserActivity(service: service, offset: offset, limit: limit);
    return list.map(ServiceActivity.fromJson).toList();
  }

  Future<void> logActivity({
    required String serviceName,
    required String actionType,
    Map<String, dynamic>? details,
  }) async {
    await _api.postUserActivity(
      serviceName: serviceName,
      actionType: actionType,
      details: details,
    );
  }
}
