import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/internet_connection/internet_connection_repository.dart';

@Injectable()
class ListenInternetConnectionUseCase {
  final InternetConnectionRepository _internetConnectionRepository;

  ListenInternetConnectionUseCase(this._internetConnectionRepository);

  Stream<bool> call() => _internetConnectionRepository.listenInternetConnection();
}