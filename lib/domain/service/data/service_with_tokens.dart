import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/domain/service/data/service_tokens.dart';

class ServiceWithTokens {
  final Service service;
  final ServiceTokens tokens;

  ServiceWithTokens({
    required this.service,
    required this.tokens,
  });
}
