import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/core/di/di_config.dart';
import 'package:logpass_me/domain/language/use_case/set_language_code_use_case.dart';
import 'package:logpass_me/domain/theme/theme_brightness.dart';
import 'package:logpass_me/domain/theme/use_case/listen_for_theme_brightness_changes_use_case.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/themes.dart';
import 'package:logpass_me/presentation/utils/brightness_utils.dart';

class LogPassMeApp extends HookWidget {
  final MainRouter mainRouter;
  final ThemeBrightness initialThemeBrightness;

  const LogPassMeApp({
    required this.mainRouter,
    required this.initialThemeBrightness,
    Key? key,
  }) : super(key: key);

  void _systemBrightnessChanged(ThemeBrightness themeBrightness) {
    if (themeBrightness == ThemeBrightness.system) {
      final brightness = WidgetsBinding.instance?.window.platformBrightness;
      if (brightness != null) updateAppThemeColors(brightness);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = context.locale.languageCode;
    useEffect(() {
      getIt<SetLanguageCodeUseCase>()(languageCode);
    }, [context.locale]);

    final themeBrightnessStream = useMemoized(() => getIt<ListenForThemeBrightnessChangesUseCase>()());
    final themeBrightness = useStream(themeBrightnessStream).data ?? initialThemeBrightness;
    final brightness = themeBrightness.toBrightness();

    useEffect(() {
      WidgetsBinding.instance?.window.onPlatformBrightnessChanged = () {
        _systemBrightnessChanged(themeBrightness);
      };
    }, []);

    useEffect(() {
      updateAppThemeColors(brightness);
    }, [brightness]);

    return MaterialApp.router(
      title: 'LogPass.me',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: lightTheme,
      darkTheme: darkTheme,
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
}
