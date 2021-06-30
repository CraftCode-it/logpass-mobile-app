part of 'messenger.dart';

typedef InfoListener = Function(String message, String? action, Function()? onAction);
typedef ErrorListener = Function(String message);

MessengerController useMessengerController() {
  final controller = useMemoized(() => MessengerController());
  useEffect(() => controller._clearListeners, [controller]);

  return controller;
}

class MessengerController {
  InfoListener? _infoListener;
  ErrorListener? _errorListener;

  void showInfo(String message) {
    _infoListener?.call(message, null, null);
  }

  void showInfoWithAction(String message, String action, Function() onAction) {
    _infoListener?.call(message, action, onAction);
  }

  void showError(String message) {
    _errorListener?.call(message);
  }

  void _clearListeners() {
    _infoListener = null;
    _errorListener = null;
  }
}
