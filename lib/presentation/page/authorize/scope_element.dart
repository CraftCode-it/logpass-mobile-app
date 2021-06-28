import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/domain/model/scope.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';
import 'package:logpass_me/domain/user_data/data/email.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';

part 'scope_element.freezed.dart';

@freezed
class ScopeElement with _$ScopeElement {
  const ScopeElement._();

  String get requiredHint => '*$hint';

  const factory ScopeElement.email(
    Scope scope,
    String name,
    String hint,
    String imagePath,
    bool isRequired, {
    Email? email,
  }) = ScopeElementEmail;

  const factory ScopeElement.invoice(
    Scope scope,
    String name,
    String hint,
    String imagePath,
    bool isRequired, {
    InvoiceData? invoiceData,
  }) = ScopeElementInvoice;

  const factory ScopeElement.address(
    Scope scope,
    String name,
    String hint,
    String imagePath,
    bool isRequired, {
    Address? address,
  }) = ScopeElementAddress;
}

extension SubmitCheck on ScopeElement {
  bool isEligible() {
    return maybeMap(
      email: (state) {
        return !isRequired || isRequired && state.email != null;
      },
      address: (state) {
        return !isRequired || isRequired && state.address != null;
      },
      invoice: (state) {
        return !isRequired || isRequired && state.invoiceData != null;
      },
      orElse: () => !isRequired,
    );
  }
}
