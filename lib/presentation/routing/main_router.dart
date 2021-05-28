import 'package:auto_route/annotations.dart';
import 'package:logpass_me/domain/country_code/country_code.dart';
import 'package:logpass_me/presentation/page/country_code/country_code_picker_page.dart';
import 'package:logpass_me/presentation/page/entry/entry_page.dart';
import 'package:logpass_me/presentation/page/onboarding/onboarding_page.dart';
import 'package:logpass_me/presentation/page/start/start_page.dart';

@AdaptiveAutoRouter(
  routes: [
    AutoRoute(page: EntryPage, initial: true),
    AutoRoute(page: OnboardingPage),
    AutoRoute(page: StartPage),
    AutoRoute<CountryCode?>(page: CountryCodePickerPage),
  ],
)
class $MainRouter {}
