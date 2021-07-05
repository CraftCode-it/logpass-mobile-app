import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/device/device.dart';
import 'package:logpass_me/domain/model/device_type.dart';

@injectable
class GetDeviceListUseCase {
  Future<List<Device>> call() async => Future.delayed(
        const Duration(seconds: 2),
        () => [
          Device(
            id: '0000-1234',
            name: 'Pixel 4a',
            trustLevel: 1,
            deviceType: DeviceType.mobile,
          ),
          Device(
            id: '0000-4312',
            name: 'Chrome 10.2.3',
            trustLevel: 1,
            deviceType: DeviceType.pc,
          ),
        ],
      );
}
