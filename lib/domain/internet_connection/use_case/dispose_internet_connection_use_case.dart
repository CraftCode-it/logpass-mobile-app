import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/internet_connection/internet_connection_repository.dart';

@Injectable()
class DisposeInternetConnectionUseCase {
  final InternetConnectionRepository _internetConnectionRepository;

  DisposeInternetConnectionUseCase(this._internetConnectionRepository);

  Future<void> call() => _internetConnectionRepository.dispose();
}