import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/data_changed_notifier/data_changed_type.dart';

@LazySingleton()
class DataChangedNotifier {
  final StreamController<DataChangedType> _streamController = StreamController.broadcast();

  void notify(DataChangedType type) => _streamController.sink.add(type);

  Stream<DataChangedType> listenForType(DataChangedType type) =>
      _streamController.stream.where((event) => event == type);
}
