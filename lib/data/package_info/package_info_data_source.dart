import 'package:injectable/injectable.dart';
import 'package:package_info/package_info.dart';

@LazySingleton()
class PackageInfoDataSource {
  final PackageInfo _packageInfo;

  const PackageInfoDataSource(this._packageInfo);

  String getApplicationVersion() => _packageInfo.version;

  String getBuildNumber() => _packageInfo.buildNumber;
}
