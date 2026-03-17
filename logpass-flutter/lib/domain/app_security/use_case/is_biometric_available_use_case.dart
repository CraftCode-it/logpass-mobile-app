import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app_security/app_security_repository.dart';

@Injectable()
class IsBiometricAvailableUseCase {
  final AppSecurityRepository _appSecurityRepository;

  IsBiometricAvailableUseCase(this._appSecurityRepository);

  Future<bool> call() => _appSecurityRepository.supportsBiometric();
}