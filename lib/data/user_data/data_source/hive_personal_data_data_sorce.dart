import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/database/database_configuration.dart';
import 'package:logpass_me/data/user_data/data_source/hive_user_data_data_source.dart';
import 'package:logpass_me/data/user_data/dto/personal_data_entity.dart';
import 'package:logpass_me/domain/crypto/crypto_keyh_provider.dart';
import 'package:logpass_me/domain/crypto/crypto_repository.dart';

@lazySingleton
class HivePersonalDataDataSource extends HiveUserDataDataSource<PersonalDataEntity> {
  HivePersonalDataDataSource(CryptoKeyProvider provider) : super(provider);

  @override
  String get boxName => DatabaseConfiguration.PERSONAL_DATA_BOX;
}
