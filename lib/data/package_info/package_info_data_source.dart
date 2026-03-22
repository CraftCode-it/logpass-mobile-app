import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

@LazySingleton()
class PackageInfoDataSource {
  final PackageInfo _packageInfo;

  const PackageInfoDataSource(this._packageInfo);

  String getApplicationVersion() => _packageInfo.version;

  String getBuildNumber() => _packageInfo.buildNumber;
}
