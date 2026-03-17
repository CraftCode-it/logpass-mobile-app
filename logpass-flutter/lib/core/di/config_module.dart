import 'package:fimber/fimber.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/core/app_env.dart';
import 'package:logpass_me/core/util/crashlytics_reporting_tree.dart';

@module
abstract class ConfigModule {
  @dev
  @Singleton()
  AppEnv get devEnv => AppEnv.development();

  @prod
  @Singleton()
  AppEnv get prodEnv => AppEnv.production();

  @dev
  @Singleton()
  LogTree get devLogTree => DebugTree(useColors: true);

  @prod
  @Singleton()
  LogTree prodLogTree(FirebaseCrashlytics crashlytics) => CrashlyticsReportingTree(crashlytics);
}
