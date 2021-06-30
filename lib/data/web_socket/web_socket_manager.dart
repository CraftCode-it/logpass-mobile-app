import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/core/app_env.dart';
import 'package:logpass_me/domain/auth/use_case/get_user_tokens_use_case.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

@Singleton()
class WebSocketManager {
  final GetUserTokensUseCase _getUserTokensUseCase;
  final AppEnv _appEnv;
  final StreamController<dynamic> _webSocketChannelBroadcast = StreamController.broadcast();

  StreamSubscription? _streamSubscription;
  late IOWebSocketChannel _webSocketChannel;
  bool closed = true;

  WebSocketManager(this._getUserTokensUseCase, this._appEnv);

  Future setupWebSocketChannel() async {
    closed = false;

    final channelUrl = _appEnv.wsUrl;
    final tokens = await _getUserTokensUseCase();

    _webSocketChannel = IOWebSocketChannel.connect(
      Uri.parse('$channelUrl${tokens.sub}'),
      pingInterval: const Duration(seconds: 1),
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
