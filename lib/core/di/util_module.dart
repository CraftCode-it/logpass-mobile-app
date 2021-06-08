import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';

@module
abstract class UtilModule {
  @LazySingleton()
  FirebaseCrashlytics get crashlytics => FirebaseCrashlytics.instance;

  @LazySingleton()
  LocalAuthentication get localAuth => LocalAuthentication();
}
