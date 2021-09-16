import 'package:logpass_me/domain/user_data/default_data.dart';

abstract class UserDataRepository<T extends DefaultData> {
  Future create(T value);

  Future<List<T>> readAll();

  Future<T?> readDefault();

  Future setDefault(T value);

  Future update(T value);

  Future delete(T value);
}
