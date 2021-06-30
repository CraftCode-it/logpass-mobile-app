import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info/package_info.dart';
import 'package:sms_autofill/sms_autofill.dart';

@module
abstract class UtilModule {
  @LazySingleton()
  FirebaseCrashlytics get crashlytics => FirebaseCrashlytics.instance;

  @LazySingleton()
  LocalAuthentication get localAuth => LocalAuthentication();

  @LazySingleton()
  SmsAutoFill get smsAutofill => SmsAutoFill();

  @preResolve
  Future<PackageInfo> getPackageInfo() => PackageInfo.fromPlatform();
}
