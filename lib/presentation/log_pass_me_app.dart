import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';

class LogPassMeApp extends StatelessWidget {
  final _mainRouter = MainRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LogPass.me',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routeInformationParser: _mainRouter.defaultRouteParser(),
      routerDelegate: _mainRouter.delegate(),
    );
  }
}
