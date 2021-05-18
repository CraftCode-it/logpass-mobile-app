import 'package:flutter/material.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';

class LogPassMeApp extends StatelessWidget {
  final _mainRouter = MainRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LogPass.me',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routeInformationParser: _mainRouter.defaultRouteParser(),
      routerDelegate: _mainRouter.delegate(),
    );
  }
}
