import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/database/database_configuration.dart';
import 'package:logpass_me/data/user_data/data_source/hive_user_data_data_source.dart';
import 'package:logpass_me/data/user_data/dto/invoice_entity.dart';
import 'package:logpass_me/domain/crypto/crypto_keyh_provider.dart';

@lazySingleton
class HiveInvoiceDataSource extends HiveUserDataDataSource<InvoiceEntity> {
  HiveInvoiceDataSource(CryptoKeyProvider provider) : super(provider);

  @override
  String get boxName => DatabaseConfiguration.INVOICES_BOX;
}
