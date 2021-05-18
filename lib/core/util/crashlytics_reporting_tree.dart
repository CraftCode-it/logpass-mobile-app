import 'package:fimber/fimber.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsReportingTree implements LogTree {
  final FirebaseCrashlytics _crashlytics;

  CrashlyticsReportingTree(this._crashlytics);

  @override
  List<String> getLevels() => ['W', 'E'];

  @override
  void log(String level, String message, {String? tag, dynamic? ex, StackTrace? stacktrace}) {
    _crashlytics.log(message);
    if (ex != null) {
      _crashlytics.recordError(ex, stacktrace, reason: message);
    }
  }
}
