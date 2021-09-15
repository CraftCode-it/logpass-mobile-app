import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/user_data/data_source/hive_addresses_data_source.dart';
import 'package:logpass_me/data/user_data/repository/user_address_data_repository.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@module
abstract class RepositoryModule {
  @LazySingleton()
  UserDataRepository<Address>  addressRepository(HiveAddressesDataSource ds) => UserAddressDataRepository(ds);
}
