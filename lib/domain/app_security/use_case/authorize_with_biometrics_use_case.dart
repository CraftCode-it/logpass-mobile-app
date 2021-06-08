import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app_security/app_security_repository.dart';

@Injectable()
class AuthorizeWithBiometricsUseCase {
  final AppSecurityRepository _appSecurityRepository;

  AuthorizeWithBiometricsUseCase(this._appSecurityRepository);

  Future<bool> call() => _appSecurityRepository.authenticate();
}