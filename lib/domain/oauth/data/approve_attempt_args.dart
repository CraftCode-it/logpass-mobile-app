import 'package:logpass_me/domain/model/scope.dart';

class ApproveAttemptArgs {
  final String email;
  final bool emailVerified;
  final String name;
  final List<Scope> extraScopes;

  ApproveAttemptArgs({
    required this.email,
    required this.emailVerified,
    required this.name,
    required this.extraScopes,
  });

  // TODO: extend model after implmentation of pages for required scopes
  // Address address
  // Invoice invoice
}
