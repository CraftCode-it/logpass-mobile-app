abstract class WebSocketRepository {
  void closeWebSocketChannel();

  Future<void> setupWebSocketChannel();
}
