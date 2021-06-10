import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/web_socket/web_socket_repository.dart';

@Injectable()
class SetupWebSocketChannelUseCase {
  final WebSocketRepository _repository;

  SetupWebSocketChannelUseCase(this._repository);

  Future call() => _repository.setupWebSocketChannel();
}
