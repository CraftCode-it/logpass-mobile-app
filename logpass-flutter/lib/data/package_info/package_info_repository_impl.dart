import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/package_info/package_info_data_source.dart';
import 'package:logpass_me/domain/package_info/package_info_repository.dart';

@LazySingleton(as: PackageInfoRepository)
class PackageInfoRepositoryImpl implements PackageInfoRepository {
  final PackageInfoDataSource _packageInfoDataSource;

  PackageInfoRepositoryImpl(this._packageInfoDataSource);

  @override
  String getApplicationVersion() => _packageInfoDataSource.getApplicationVersion();

  @override
  String getBuildNumber() => _packageInfoDataSource.getBuildNumber();
}
