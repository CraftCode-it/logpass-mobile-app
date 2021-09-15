import 'dart:async';
import 'dart:isolate';

import 'package:bloc/bloc.dart';
import 'package:country_codes/country_codes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logpass_me/core/bloc/simple_bloc_observer.dart';
import 'package:logpass_me/core/di/di_config.dart';
import 'package:logpass_me/domain/language/language_code.dart';
import 'package:logpass_me/domain/theme/theme_brightness.dart';
import 'package:logpass_me/domain/theme/use_case/get_theme_brightness_use_case.dart';
import 'package:logpass_me/presentation/log_pass_me_app.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/utils/brightness_utils.dart';
import 'package:logpass_me/data/user_data/dto/address_dto.dart';

Future<void> runMain(String env) async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await initHive();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp();
  await setupCrashlytics();

  await runZonedGuarded<Future<void>>(() async {
    await _precacheSvgImages();
    await CountryCodes.init();

    await configureDependencies(env);
    setupFimber();

    final themeBrightness = await getInitialBrightnessTheme();
    setupAppThemeColor(themeBrightness.toBrightness());
    final mainRouter = MainRouter();

    runApp(
      EasyLocalization(
        path: 'assets/translations',
        supportedLocales: availableLocales.values.toList(),
        fallbackLocale: availableLocales[fallbackLanguageCode],
        useOnlyLangCode: true,
        saveLocale: true,
        child: LogPassMeApp(
          mainRouter: mainRouter,
          initialThemeBrightness: themeBrightness,
        ),
      ),
    );
  }, FirebaseCrashlytics.instance.recordError);
}

void setupFimber() => Fimber.plantTree(getIt());

Future<void> setupCrashlytics() async {
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    return;
  }

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final errorAndStacktrace = pair as List<dynamic>;
    await FirebaseCrashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last as StackTrace?,
    );
  }).sendPort);
}

Future<ThemeBrightness> getInitialBrightnessTheme() => getIt<GetThemeBrightnessUseCase>()();

Future<void> _precacheSvgImages() async {
  await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, AppIcon.successLight), null);
  await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, AppIcon.successDark), null);
  await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, AppIcon.failureLight), null);
  await precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, AppIcon.failureDark), null);
}


Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AddressDtoAdapter());
}
