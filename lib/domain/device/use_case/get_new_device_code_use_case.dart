import 'package:injectable/injectable.dart';

@injectable
class GetNewDeviceCodeUseCase {
  Future<String> call() => Future.delayed(const Duration(seconds: 2), () => '123444');
}
