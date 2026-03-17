import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/web_socket/web_socket_repository.dart';

@Injectable()
class CloseWebSocketUseCase {
  final WebSocketRepository _repository;

  CloseWebSocketUseCase(this._repository);

  void call() => _repository.closeWebSocketChannel();
}
