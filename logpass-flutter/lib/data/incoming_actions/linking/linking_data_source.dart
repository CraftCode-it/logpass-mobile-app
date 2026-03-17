import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:uni_links/uni_links.dart';

class LinkingDataSource {
  final StreamController<String> _incomingUriController = StreamController.broadcast();

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
        _incomingUriController.sink.add(event);
      }
    });
  }

  Future<String?> getInitialAction() async {
    return _initialRoute;
  }

  Stream<String> listenForIncomingActions() => _incomingUriController.stream;

  Future<void> clear() async {
    await _incomingUriSubscription?.cancel();
  }
}
