import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

@module
abstract class UtilModule {
  @LazySingleton()
  FirebaseCrashlytics get crashlytics => FirebaseCrashlytics.instance;

  @LazySingleton()
  LocalAuthentication get localAuth => LocalAuthentication();

  @preResolve
  Future<PackageInfo> getPackageInfo() => PackageInfo.fromPlatform();

  @lazySingleton
  DeviceInfoPlugin getDeviceInfoPlugin() => DeviceInfoPlugin();
}
