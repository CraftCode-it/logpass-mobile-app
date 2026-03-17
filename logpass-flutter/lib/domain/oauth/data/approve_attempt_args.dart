import 'package:logpass_me/domain/model/scope.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';

class ApproveAttemptArgs {
  final String email;
  final bool emailVerified;
  final String? phoneNumber;
  final bool phoneNumberVerified;
  final String? name;
  final String? surname;
  final String locale;
  final List<Scope> extraScopes;
  final Address? address;
  final InvoiceData? invoice;

  ApproveAttemptArgs({
    required this.email,
    required this.emailVerified,
    required this.extraScopes,
    required this.phoneNumberVerified,
    required this.locale,
    this.name,
    this.surname,
    this.phoneNumber,
    this.address,
    this.invoice,
  });
}
