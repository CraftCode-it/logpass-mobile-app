import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/model/scope.dart';
import 'package:logpass_me/domain/service/data/service_supported_scopes.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';
import 'package:logpass_me/domain/user_data/data/email.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';
import 'package:logpass_me/presentation/page/authorize/scope_element.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

@injectable
class ScopeRenderer {
  List<ScopeElement> renderScopes(
    List<Scope> requestedScopes,
    List<ServiceSupportedScopes> supportedScopes, {
    Email? userEmail,
    Address? userAddress,
    InvoiceData? invoiceData,
  }) {
    final list = supportedScopes
        .map((e) {
          switch (e.scope) {
            case Scope.address:
              return ScopeElement.address(
                e.scope,
                LocaleKeys.authorize_addressScopeName.tr(),
                LocaleKeys.authorize_addressScopeHint.tr(),
                AppIcon.address,
                requestedScopes.contains(e.scope),
                address: userAddress,
              );
            case Scope.email:
              return ScopeElement.email(
                e.scope,
                LocaleKeys.authorize_emailScopeName.tr(),
                LocaleKeys.authorize_emailScopeHint.tr(),
                AppIcon.email,
                requestedScopes.contains(e.scope),
                email: userEmail,
              );
            case Scope.invoice:
              return ScopeElement.invoice(
                e.scope,
                LocaleKeys.authorize_invoiceScopeName.tr(),
                LocaleKeys.authorize_invoiceScopeHint.tr(),
                AppIcon.invoiceData,
                requestedScopes.contains(e.scope),
                invoiceData: invoiceData,
              );
            default:
              break;
          }
        })
        .whereType<ScopeElement>()
        .toList();

    return list;
  }
}
