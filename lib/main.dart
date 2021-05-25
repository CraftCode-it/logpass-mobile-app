import 'dart:async';
import 'dart:isolate';

import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logpass_me/core/available_locales.dart';
import 'package:logpass_me/core/di/di_config.dart';
import 'package:logpass_me/presentation/log_pass_me_app.dart';

Future<void> runMain(String env) async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await setupCrashlytics();

  await runZonedGuarded<Future<void>>(() async {
    configureDependencies(env);
    setupFimber();

    runApp(
      EasyLocalization(
        path: 'assets/translations',
        supportedLocales: availableLocales.values.toList(),
        fallbackLocale: availableLocales[LanguageCode.en],
        useOnlyLangCode: true,
        saveLocale: true,
        child: LogPassMeApp(),
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
