import 'package:injectable/injectable.dart';
import 'package:logpass_me/core/app_env.dart';
import 'package:logpass_me/domain/auth/use_case/get_user_tokens_use_case.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

@Singleton()
class WebSocketManager {
  final GetUserTokensUseCase _getUserTokensUseCase;
  final AppEnv _appEnv;

  late IOWebSocketChannel _webSocketChannel;
  final BehaviorSubject<dynamic> _webSocketChannelBroadcast = BehaviorSubject();

  WebSocketManager(this._getUserTokensUseCase, this._appEnv);

  Future setupWebSocketChannel() async {
    final channelUrl = _appEnv.wsUrl;
    final tokens = await _getUserTokensUseCase();

    try {
      _webSocketChannel = IOWebSocketChannel.connect(
        Uri.parse('$channelUrl${tokens.sub}'),
        pingInterval: const Duration(seconds: 1),
      )..stream.listen((event) {
          _webSocketChannelBroadcast.add(event);
        });
    } on Exception catch (e, s) {
      print(e);
    }
  }

  Stream<dynamic> listenForChannel() => _webSocketChannelBroadcast.stream;

  void closeChannel() {
    _webSocketChannel.sink.close(status.goingAway);
  }
}
