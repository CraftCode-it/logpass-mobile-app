import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/user_data/data_source/hive_address_data_sorce.dart';
import 'package:logpass_me/data/user_data/data_source/hive_email_data_sorce.dart';
import 'package:logpass_me/data/user_data/data_source/hive_invoice_data_sorce.dart';
import 'package:logpass_me/data/user_data/data_source/hive_personal_data_data_sorce.dart';
import 'package:logpass_me/data/user_data/mapper/address_dto_to_address_mapper.dart';
import 'package:logpass_me/data/user_data/mapper/email_dto_mapper.dart';
import 'package:logpass_me/data/user_data/mapper/invoice_dto_to_invoice_mapper.dart';
import 'package:logpass_me/data/user_data/mapper/personal_data_dto_mapper.dart';
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
  UserDataRepository<Address> addressRepository(HiveAddressDataSource ds, AddressDtoToAddressMapper mapper) =>
      UserAddressDataRepository(ds, mapper);

  @LazySingleton()
  UserDataRepository<InvoiceData> invoiceRepository(HiveInvoiceDataSource ds, InvoiceDtoToInvoiceMapper mapper) =>
      UserInvoiceDataRepository(ds, mapper);

  @LazySingleton()
  UserDataRepository<Email> emailRepository(HiveEmailDataSource ds, EmailDtoMapper mapper) =>
      UserEmailDataRepository(ds, mapper);

  @LazySingleton()
  UserDataRepository<PersonalData> personalDataRepository(
          HivePersonalDataDataSource ds, PersonalDataDtoMapper mapper) =>
      UserPersonalDataRepository(ds, mapper);
}
