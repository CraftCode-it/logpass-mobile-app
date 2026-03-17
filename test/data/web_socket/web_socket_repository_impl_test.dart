import 'package:flutter_test/flutter_test.dart';
import 'package:logpass_me/data/web_socket/web_socket_manager.dart';
import 'package:logpass_me/data/web_socket/web_socket_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'web_socket_repository_impl_test.mocks.dart';

@GenerateMocks(
  [
    WebSocketManager,
  ],
)
void main() {
  late MockWebSocketManager webSocketManger;
  late WebSocketRepositoryImpl webSocketRepositoryImpl;

  setUp(() {
    webSocketManger = MockWebSocketManager();
    webSocketRepositoryImpl = WebSocketRepositoryImpl(webSocketManger);
  });

  group('opening WS channel', () {
    test('opens web socket channel successfully', () async {
      when(webSocketManger.setupWebSocketChannel()).thenAnswer((realInvocation) async => {});

      await webSocketRepositoryImpl.setupWebSocketChannel();

      verify(webSocketManger.setupWebSocketChannel());
    });

    test('throws exception when there\'s problem with web channel setup', () async {
      final expected = Exception();

      when(webSocketManger.setupWebSocketChannel()).thenAnswer((realInvocation) async => throw expected);

      expect(webSocketRepositoryImpl.setupWebSocketChannel(), throwsA(expected));
    });
  });

  group('closing WS channel', () {
    test('closes web socket channel successfully', () {
      when(webSocketManger.closeChannel()).thenAnswer((realInvocation) => {});

      webSocketRepositoryImpl.closeWebSocketChannel();

      verify(webSocketManger.closeChannel());
    });
  });
}
