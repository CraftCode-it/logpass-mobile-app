import 'package:auto_route/annotations.dart';
import 'package:logpass_me/domain/country_code/country_code.dart';
import 'package:logpass_me/domain/service/data/service_agreement.dart';
import 'package:logpass_me/presentation/page/add_new_device/add_new_device_page.dart';
import 'package:logpass_me/presentation/page/agreement_details/agreement_details_page.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';
import 'package:logpass_me/domain/user_data/data/email.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';
import 'package:logpass_me/presentation/page/authorize/address_selection/address_selection_page.dart';
import 'package:logpass_me/presentation/page/authorize/agreement_content_preview/agreement_content_preview_page.dart';
import 'package:logpass_me/presentation/page/authorize/authorize_page.dart';
import 'package:logpass_me/presentation/page/authorize/email_selection/email_selection_page.dart';
import 'package:logpass_me/presentation/page/authorize/invoice_data_selection/invoice_data_selection_page.dart';
import 'package:logpass_me/presentation/page/authorize/service_rules/service_rules_page.dart';
import 'package:logpass_me/presentation/page/country_code/country_code_picker_page.dart';
import 'package:logpass_me/presentation/page/entry/entry_page.dart';
import 'package:logpass_me/presentation/page/get_safer/get_safer_page.dart';
import 'package:logpass_me/presentation/page/home/home_page.dart';
import 'package:logpass_me/presentation/page/language/language_page.dart';
import 'package:logpass_me/presentation/page/login_success/login_success_page.dart';
import 'package:logpass_me/presentation/page/main/main_page.dart';
import 'package:logpass_me/presentation/page/onboarding/onboarding_page.dart';
import 'package:logpass_me/presentation/page/otp_code/otp_code_page.dart';
import 'package:logpass_me/presentation/page/pin_setup/confirm_pin/confirm_pin_page.dart';
import 'package:logpass_me/presentation/page/pin_setup/confirm_with_pin/confirm_with_pin_page.dart';
import 'package:logpass_me/presentation/page/pin_setup/new_pin/new_pin_page.dart';
import 'package:logpass_me/presentation/page/pin_setup/pin_success/pin_success_page.dart';
import 'package:logpass_me/presentation/page/secured_login/secured_login_page.dart';
import 'package:logpass_me/presentation/page/security_settings/security_settings_page.dart';
import 'package:logpass_me/presentation/page/service_details/service_details_page.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/historical_session_list_page.dart';
import 'package:logpass_me/presentation/page/start/start_page.dart';
import 'package:logpass_me/presentation/page/terms_and_conditions/terms_and_conditions_page.dart';

@AdaptiveAutoRouter(
  routes: [
    AutoRoute(page: EntryPage, initial: true),
    AutoRoute(page: OnboardingPage),
    AutoRoute(page: StartPage),
    AutoRoute(page: AddNewDevicePage),
    AutoRoute<CountryCode?>(page: CountryCodePickerPage),
    AutoRoute(page: OTPCodePage),
    AutoRoute(page: HomePage),
    AutoRoute(page: GetSaferPage),
    AutoRoute(page: LoginSuccessPage),
    AutoRoute(page: MainPage),
    AutoRoute(page: NewPinPage),
    AutoRoute(page: ConfirmPinPage),
    AutoRoute(page: PinSuccessPage),
    AutoRoute(page: SecuredLoginPage),
    AutoRoute(page: ServiceDetailsPage),
    AutoRoute(page: HistoricalSessionListPage),
    AutoRoute(page: AuthorizePage),
    AutoRoute(page: AgreementDetailsPage),
    AutoRoute<Email?>(page: EmailSelectionPage),
    AutoRoute<Address?>(page: AddressSelectionPage),
    AutoRoute<InvoiceData?>(page: InvoiceDataSelectionPage),
    AutoRoute(page: SecuritySettingsPage),
    AutoRoute(page: ConfirmWithPinPage),
    AutoRoute(page: LanguagePage),
    AutoRoute(page: TermsAndConditionsPage),
    AutoRoute<List<ServiceAgreement>>(page: ServiceRulesPage),
    AutoRoute(page: AgreementContentPreviewPage),
  ],
)
class $MainRouter {}
