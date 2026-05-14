import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/networking/error/dio_error_resolver.dart';
import 'package:logpass_me/data/networking/error/general_dio_error_wrapper.dart';
import 'package:logpass_me/data/networking/error/logpass_dio_error_wrapper.dart';
import 'package:logpass_me/data/networking/log_pass_dio.dart';
import 'package:rxdart/rxdart.dart';

@LazySingleton()
class InternetConnectionManager {
  final Connectivity _connectivity;
  final LogPassDio _dio;

  InternetConnectionManager(this._connectivity, this._dio);

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final BehaviorSubject<bool> _internetConnectionSubject = BehaviorSubject<bool>();

  void init() {
    _connectivitySubscription = _connectivity
        .onConnectivityChanged
        .listen(_updateConnectionStatus);
  }

  Future<bool> hasInternetConnection() async {
    final result = await _connectivity.checkConnectivity();

    return _mapInternetConnection(result);
  }

  Stream<bool> listenInternetConnection() => _internetConnectionSubject.stream;

  void dispose() {
    _connectivitySubscription.cancel();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult event) async {
    final hasConnection = await _mapInternetConnection(event);
    _internetConnectionSubject.add(hasConnection);
  }

  Future<bool> _mapInternetConnection(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      return false;
    }
    if (result == ConnectivityResult.mobile) {
      return true;
    }
    if (result == ConnectivityResult.wifi) {
      return _pingLogpassServer();
    }
    return _pingLogpassServer();
  }

  Future<bool> _pingLogpassServer() async {
    try {
      await callWithDioErrorResolver(
        () => _dio.get('/users/self/logs/'),
      );
      return true;
    } on GeneralDioErrorWrapper catch (_) {
      return false;
    } on LogpassDioErrorWrapper catch (_) {
      return true;
    }
  }
}
