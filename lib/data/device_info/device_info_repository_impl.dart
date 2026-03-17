import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/device_info/device_info_data_source.dart';
import 'package:logpass_me/domain/device_info/device_info_repository.dart';

@LazySingleton(as: DeviceInfoRepository)
class DeviceInfoRepositoryImpl implements DeviceInfoRepository {
  final DeviceInfoDataSource _deviceInfoDataSource;

  DeviceInfoRepositoryImpl(this._deviceInfoDataSource);

  @override
  Future<String> getDeviceName() => _deviceInfoDataSource.getDeviceName();
}
