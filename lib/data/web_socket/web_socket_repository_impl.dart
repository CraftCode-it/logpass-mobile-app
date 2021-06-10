import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/web_socket/web_socket_manager.dart';
import 'package:logpass_me/domain/web_socket/web_socket_repository.dart';

@Singleton(as: WebSocketRepository)
class WebSocketRepositoryImpl implements WebSocketRepository {
  final WebSocketManager _webSocketManager;

  WebSocketRepositoryImpl(this._webSocketManager);

  @override
  void closeWebSocketChannel() {
    _webSocketManager.closeChannel();
  }

  @override
  Future<void> setupWebSocketChannel() async {
    await _webSocketManager.setupWebSocketChannel();
  }
}
