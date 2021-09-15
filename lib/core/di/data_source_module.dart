import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/incoming_actions/linking/linking_data_source.dart';
import 'package:logpass_me/data/user_data/data_source/hive_user_data_data_source.dart';
import 'package:logpass_me/data/user_data/dto/address_dto.dart';
import 'package:logpass_me/data/user_data/dto/invoice_dto.dart';

@module
abstract class DataSourceModule {
  @preResolve
  Future<LinkingDataSource> getLinkingDataSource() => LinkingDataSource.create();

  @lazySingleton
  HiveUserDataDataSource<AddressDto> getAddressHiveDataSource(
    Box<AddressDto> box,
  ) =>
      HiveUserDataDataSource<AddressDto>(box);

  @lazySingleton
  HiveUserDataDataSource<InvoiceDto> getInvoiceHiveDataSource(
    Box<InvoiceDto> box,
  ) =>
      HiveUserDataDataSource<InvoiceDto>(box);
}
