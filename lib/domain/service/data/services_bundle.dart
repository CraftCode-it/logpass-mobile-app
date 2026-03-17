import 'package:logpass_me/domain/service/data/service_with_tokens.dart';

class ServicesBundle {
  final int totalCount;
  final List<ServiceWithTokens> services;

  ServicesBundle(this.totalCount, this.services);
}
