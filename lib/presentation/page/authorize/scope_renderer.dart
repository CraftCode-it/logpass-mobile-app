import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/model/scope.dart';
import 'package:logpass_me/domain/service/data/service_supported_scopes.dart';
import 'package:logpass_me/presentation/page/authorize/scope_element.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

@injectable
class ScopeRenderer {
  List<ScopeElement> renderScopes(List<Scope> requestedScopes, List<ServiceSupportedScopes> supportedScopes) {
    final list = supportedScopes
        .map((e) {
          switch (e.scope) {
            case Scope.address:
              return ScopeElement(
                scope: e.scope,
                name: LocaleKeys.authorize_addressScopeName.tr(),
                hint: LocaleKeys.authorize_addressScopeHint.tr(),
                imagePath: AppIcon.address,
                isRequired: requestedScopes.contains(e.scope),
              );
            case Scope.email:
              return ScopeElement(
                scope: e.scope,
                name: LocaleKeys.authorize_emailScopeName.tr(),
                hint: LocaleKeys.authorize_emailScopeHint.tr(),
                imagePath: AppIcon.email,
                isRequired: requestedScopes.contains(e.scope),
              );
            case Scope.invoice:
              return ScopeElement(
                scope: e.scope,
                name: LocaleKeys.authorize_invoiceScopeName.tr(),
                hint: LocaleKeys.authorize_invoiceScopeHint.tr(),
                imagePath: AppIcon.invoiceData,
                isRequired: requestedScopes.contains(e.scope),
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
