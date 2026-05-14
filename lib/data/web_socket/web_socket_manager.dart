import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/auth/use_case/get_user_tokens_use_case.dart';
import 'package:logpass_me/domain/push_notifications/use_case/get_push_notification_device_use_case.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

@Singleton()
class WebSocketManager {
  final GetNotificationDeviceUseCase _getNotificationDeviceUseCase;
  final GetUserTokensUseCase _getUserTokensUseCase;
  final StreamController<dynamic> _webSocketChannelBroadcast = StreamController.broadcast();

  StreamSubscription? _streamSubscription;
  late IOWebSocketChannel _webSocketChannel;
  bool closed = true;

  WebSocketManager(this._getNotificationDeviceUseCase, this._getUserTokensUseCase);

  static const _fallbackWsUrl = 'wss://logpass.me/ws/';

  Future setupWebSocketChannel() async {
    closed = false;

    String host;
    try {
      final device = await _getNotificationDeviceUseCase();
      host = device.webSocketUrl;
    } catch (_) {
      host = _fallbackWsUrl;
    }
    final userToken = await _getUserTokensUseCase();

    final wsUri = Uri.parse(host).replace(
      queryParameters: {'access_token': userToken.accessToken.token},
    );

    _webSocketChannel = IOWebSocketChannel.connect(
      wsUri,
      pingInterval: const Duration(seconds: 30),
    );

    _streamSubscription = _webSocketChannel.stream.listen(
      (event) {
        _webSocketChannelBroadcast.add(event);
      },
      onDone: () async {
        if (!closed) {
          await Future.delayed(const Duration(seconds: 1));
          Fimber.d('Trying to open WS connection.');
          await setupWebSocketChannel();
        } else {
          Fimber.d('WS connection has been closed.');
        }
      },
    );
  }

  Stream<dynamic> listenForChannel() => _webSocketChannelBroadcast.stream;

  void closeChannel() {
    closed = true;

    _streamSubscription?.cancel();
    _webSocketChannel.sink.close(status.goingAway);
  }
}
