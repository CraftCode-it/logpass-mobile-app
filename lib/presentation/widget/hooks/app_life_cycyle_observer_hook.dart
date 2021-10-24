import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef AppLifecycleListener = void Function(
    AppLifecycleState currentAppState, AppLifecycleState previusAppState, BuildContext context);

void useAppLifecycleStateListener(AppLifecycleListener listener, {BuildContext? context}) {
  useEffect(() {
    final _hookContext = useContext();
    final _internalCallback =
        (AppLifecycleState state, AppLifecycleState prev) => listener(state, prev, context ?? _hookContext);

    final observer = _AppLifecycleStateObserver(_internalCallback);
    WidgetsBinding.instance!.addObserver(observer);
    return () {
      WidgetsBinding.instance!.removeObserver(observer);
    };
  }, [listener]);
}

class _AppLifecycleStateObserver extends WidgetsBindingObserver {
  final _InternalObserver _listener;
  AppLifecycleState? _previousState;

  _AppLifecycleStateObserver(
    this._listener,
  );

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _listener(
      state,
      _previousState ?? state,
    );
    _previousState = state;
  }
}

typedef _InternalObserver = void Function(AppLifecycleState currentState, AppLifecycleState previousState);
