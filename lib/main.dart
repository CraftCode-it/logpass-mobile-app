import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logpass_me/core/app_env.dart';
import 'package:logpass_me/core/bloc/simple_bloc_observer.dart';
import 'package:logpass_me/core/di/di_config.dart';
import 'package:logpass_me/data/user_data/entity/address_entity.dart';
import 'package:logpass_me/data/user_data/entity/email_entity.dart';
import 'package:logpass_me/data/user_data/entity/invoice_entity.dart';
import 'package:logpass_me/data/user_data/entity/personal_data_entity.dart';
import 'package:logpass_me/domain/language/language_code.dart';
import 'package:logpass_me/domain/theme/theme_brightness.dart';
import 'package:logpass_me/domain/theme/use_case/get_theme_brightness_use_case.dart';
import 'package:logpass_me/presentation/log_pass_me_app.dart';
import 'package:logpass_me/presentation/routing/main_router.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/utils/brightness_utils.dart';

Future<void> runMain(String env) async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await initHive();
  await EasyLocalization.ensureInitialized();

  await _initFirebase(env);
  await setupCrashlytics();
  await setupCertificate();

  await runZonedGuarded<Future<void>>(() async {
    await _precacheSvgImages();

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
  }, (error, stack) {
    debugPrint('Uncaught error: $error\n$stack');
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
  });
}

/// Initializes Firebase based on build environment.
/// Dev: uses stub options (no real google-services.json required).
/// Prod: uses google-services.json via default initialization.
Future<void> _initFirebase(String env) async {
  try {
    Firebase.app();
    debugPrint('Firebase already initialized.');
    return;
  } catch (_) {}

  if (env == AppEnv.devName) {
    try {
      // API key must start with 'AIza' to pass Firebase Installations checks (blacklist #7).
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSy000000000000000000000000000000000',
          appId: '1:000000000000:android:0000000000000001',
          messagingSenderId: '000000000000',
          projectId: 'logpass-stub',
        ),
      );
      debugPrint('Firebase initialized with stub options (dev).');
    } catch (e) {
      debugPrint('Firebase stub init failed: $e');
    }
  } else {
    try {
      await Firebase.initializeApp();
      debugPrint('Firebase initialized (prod).');
    } catch (e) {
      debugPrint('Firebase prod init failed: $e');
    }
  }
}

Future<void> setupCertificate() async {
  final data = await PlatformAssetBundle().load('assets/cert/lets-encrypt-r3.pem');
  SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
}

void setupFimber() => Fimber.plantTree(getIt());

Future<void> setupCrashlytics() async {
  try {
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
  } catch (e) {
    debugPrint('Crashlytics setup failed (expected in dev): $e');
  }
}

Future<ThemeBrightness> getInitialBrightnessTheme() => getIt<GetThemeBrightnessUseCase>()();

Future<void> _precacheSvgImages() async {
  for (final asset in [AppIcon.successLight, AppIcon.successDark, AppIcon.failureLight, AppIcon.failureDark]) {
    final loader = SvgAssetLoader(asset);
    await svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
  }
}

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AddressEntityAdapter());
  Hive.registerAdapter(InvoiceEntityAdapter());
  Hive.registerAdapter(EmailEntityAdapter());
  Hive.registerAdapter(PersonalDataEntityAdapter());
}
