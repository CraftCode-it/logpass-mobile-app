import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/user_data/cipher/user_data_cipher.dart';
import 'package:logpass_me/data/user_data/data_source/hive/hive_address_data_sorce.dart';
import 'package:logpass_me/data/user_data/data_source/hive/hive_email_data_sorce.dart';
import 'package:logpass_me/data/user_data/data_source/hive/hive_invoice_data_sorce.dart';
import 'package:logpass_me/data/user_data/data_source/hive/hive_personal_data_data_sorce.dart';
import 'package:logpass_me/data/user_data/mapper/entity/address_entity_to_address_mapper.dart';
import 'package:logpass_me/data/user_data/mapper/entity/email_entity_mapper.dart';
import 'package:logpass_me/data/user_data/mapper/entity/invoice_entity_to_invoice_mapper.dart';
import 'package:logpass_me/data/user_data/mapper/entity/personal_data_entity_mapper.dart';
import 'package:logpass_me/data/user_data/repository/user_address_data_repository.dart';
import 'package:logpass_me/data/user_data/repository/user_email_data_repository.dart';
import 'package:logpass_me/data/user_data/repository/user_invoice_data_repository.dart';
import 'package:logpass_me/data/user_data/repository/user_personal_data_repository.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';
import 'package:logpass_me/domain/user_data/data/email.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';
import 'package:logpass_me/domain/user_data/data/personal_data.dart';
import 'package:logpass_me/domain/user_data/repository/user_data_repository.dart';

@module
abstract class RepositoryModule {
  @LazySingleton()
  UserDataRepository<Address> addressRepository(
          HiveAddressDataSource ds, AddressEntityToAddressEntityMapper mapper, UserDataCipher cipher) =>
      UserAddressDataRepository(ds, mapper, cipher);

  @LazySingleton()
  UserDataRepository<InvoiceData> invoiceRepository(HiveInvoiceDataSource ds, InvoiceEntityToInvoiceMapper mapper) =>
      UserInvoiceDataRepository(ds, mapper);

  @LazySingleton()
  UserDataRepository<Email> emailRepository(HiveEmailDataSource ds, EmailEntityMapper mapper) =>
      UserEmailDataRepository(ds, mapper);

  @LazySingleton()
  UserDataRepository<PersonalData> personalDataRepository(
          HivePersonalDataDataSource ds, PersonalEntityDtoMapper mapper) =>
      UserPersonalDataRepository(ds, mapper);
}
