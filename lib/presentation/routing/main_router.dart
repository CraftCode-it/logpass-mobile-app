import 'package:auto_route/annotations.dart';
import 'package:logpass_me/presentation/page/entry/entry_page.dart';
import 'package:logpass_me/presentation/page/onboarding/onboarding_page.dart';

@AdaptiveAutoRouter(
  routes: [
    AutoRoute(page: EntryPage, initial: true),
    AutoRoute(page: OnboardingPage),
  ],
)
class $MainRouter {}
