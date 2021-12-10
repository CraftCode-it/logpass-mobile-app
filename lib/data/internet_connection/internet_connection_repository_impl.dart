import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/internet_connection/internet_connection_manager.dart';
import 'package:logpass_me/domain/internet_connection/internet_connection_repository.dart';

@LazySingleton(as: InternetConnectionRepository)
class InternetConnectionRepositoryImpl implements InternetConnectionRepository {
  final InternetConnectionManager _internetConnectionManager;

  InternetConnectionRepositoryImpl(this._internetConnectionManager);

  @override
  Future<bool> hasInternetConnection() => _internetConnectionManager.hasInternetConnection();

  @override
  Stream<bool> listenInternetConnection() {
    _internetConnectionManager.init();

    return _internetConnectionManager.listenInternetConnection();
  }

  @override
  Future<void> dispose() async {
    _internetConnectionManager.dispose();
  }
}