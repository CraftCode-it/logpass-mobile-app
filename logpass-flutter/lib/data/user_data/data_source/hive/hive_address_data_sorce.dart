import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/database/database_configuration.dart';
import 'package:logpass_me/data/user_data/data_source/hive/hive_user_data_data_source.dart';
import 'package:logpass_me/data/user_data/entity/address_entity.dart';
import 'package:logpass_me/domain/crypto/crypto_key_provider.dart';

@lazySingleton
class HiveAddressDataSource extends HiveUserDataDataSource<AddressEntity> {
  HiveAddressDataSource(CryptoKeyProvider provider) : super(provider);

  @override
  String get boxName => DatabaseConfiguration.ADDRESSES_BOX;
}
