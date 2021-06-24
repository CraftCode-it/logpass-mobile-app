import 'package:logpass_me/domain/model/scope.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';

class ApproveAttemptArgs {
  final String email;
  final bool emailVerified;
  final String name;
  final List<Scope> extraScopes;
  final Address? address;
  final InvoiceData? invoice;

  ApproveAttemptArgs({
    required this.email,
    required this.emailVerified,
    required this.name,
    required this.extraScopes,
    this.address,
    this.invoice,
  });
}
