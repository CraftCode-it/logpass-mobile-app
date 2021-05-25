import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/core/di/di_config.dart';
import 'package:logpass_me/domain/language/use_case/set_language_code_use_case.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';

class LogPassMeApp extends HookWidget {
  final MainRouter mainRouter;

  const LogPassMeApp({required this.mainRouter, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageCode = context.locale.languageCode;
    useEffect(() {
      getIt<SetLanguageCodeUseCase>()(languageCode);
      return () {};
    }, [context.locale]);

    return MaterialApp.router(
      title: 'LogPass.me',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // darkTheme: ,
      // themeMode: ThMode,
      routeInformationParser: mainRouter.defaultRouteParser(),
      routerDelegate: mainRouter.delegate(),
    );
  }
}
