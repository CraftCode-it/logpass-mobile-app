import 'package:injectable/injectable.dart';

@injectable
class UpdateDeviceListUseCase {
  Future<void> call() => Future.delayed(const Duration(seconds: 3));
}
