import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/core/di/di_config.dart';
import 'package:logpass_me/domain/language/use_case/set_language_code_use_case.dart';
import 'package:logpass_me/domain/theme/theme_brightness.dart';
import 'package:logpass_me/domain/theme/use_case/listen_for_theme_brightness_changes_use_case.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';

class LogPassMeApp extends HookWidget {
  final MainRouter mainRouter;
  final ThemeBrightness initialThemeBrightness;

  const LogPassMeApp({
    required this.mainRouter,
    required this.initialThemeBrightness,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageCode = context.locale.languageCode;
    useEffect(() {
      getIt<SetLanguageCodeUseCase>()(languageCode);
      return () {};
    }, [context.locale]);

    final themeBrightness = useStream(getIt<ListenForThemeBrightnessChangesUseCase>()()).data ?? initialThemeBrightness;
    final brightness = _mapThemeBrightnessToBrightness(themeBrightness, context);

    useEffect(() {
      updateAppThemeColors(brightness);
      return () {};
    }, [brightness]);

    return MaterialApp.router(
      title: 'LogPass.me',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        brightness: Brightness.light,
        backgroundColor: AppColors.backgroundLight,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: AppColors.backgroundDark,
      ),
      themeMode: _mapThemeBrightnessToThemeMode(themeBrightness),
      routeInformationParser: mainRouter.defaultRouteParser(),
      routerDelegate: mainRouter.delegate(),
    );
  }

  ThemeMode _mapThemeBrightnessToThemeMode(ThemeBrightness brightness) {
    switch (brightness) {
      case ThemeBrightness.light:
        return ThemeMode.light;
      case ThemeBrightness.dark:
        return ThemeMode.dark;
      case ThemeBrightness.system:
        return ThemeMode.system;
    }
  }

  Brightness _mapThemeBrightnessToBrightness(ThemeBrightness brightness, BuildContext context) {
    switch (brightness) {
      case ThemeBrightness.light:
        return Brightness.light;
      case ThemeBrightness.dark:
        return Brightness.dark;
      case ThemeBrightness.system:
        return MediaQuery.platformBrightnessOf(context);
    }
  }
}
