import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/internet_connection/internet_connection_repository.dart';

@Injectable()
class GetInternetConnectionUseCase {
  final InternetConnectionRepository _internetConnectionRepository;

  GetInternetConnectionUseCase(this._internetConnectionRepository);

  Future<bool> call() => _internetConnectionRepository.hasInternetConnection();
}