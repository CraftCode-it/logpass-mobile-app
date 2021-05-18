import 'package:auto_route/annotations.dart';
import 'package:logpass_me/presentation/page/entry/entry_page.dart';

@AdaptiveAutoRouter(
  routes: [
    AutoRoute(page: EntryPage, initial: true),
  ],
)
class $MainRouter {}
