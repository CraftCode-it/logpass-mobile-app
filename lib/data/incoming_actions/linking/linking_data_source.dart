import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:logpass_me/data/incoming_actions/dtos/incoming_action_dto.dart';
import 'package:uni_links/uni_links.dart';

class LinkingDataSource {
  final StreamController<IncomingActionDTO> _incomingUriController = StreamController.broadcast();

  String? _initialRoute;
  StreamSubscription? _incomingUriSubscription;

  LinkingDataSource._();

  static Future<LinkingDataSource> create() async {
    final dataSource = LinkingDataSource._();
    await dataSource._initialize();
    return dataSource;
  }

  Future<void> _initialize() async {
    try {
      _initialRoute = await getInitialLink();
    } catch (e, s) {
      Fimber.e('Getting initial route URI failed', ex: e, stacktrace: s);
    }

    _incomingUriSubscription = linkStream.listen((event) {
      if (event != null) {
        _incomingUriController.sink.add(IncomingActionDTO(event));
      }
    });
  }

  Future<IncomingActionDTO?> getInitialAction() async {
    final initialRoute = _initialRoute;
    return initialRoute == null ? null : IncomingActionDTO(initialRoute);
  }

  Stream<IncomingActionDTO> listenForIncomingActions() => _incomingUriController.stream;

  Future<void> clear() async {
    await _incomingUriSubscription?.cancel();
  }
}
