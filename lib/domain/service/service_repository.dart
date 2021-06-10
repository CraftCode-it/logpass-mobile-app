import 'package:logpass_me/domain/service/data/services_bundle.dart';

abstract class ServiceRepository {
  Future<ServicesBundle> getPageOfServices(int page);
}