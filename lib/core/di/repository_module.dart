import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/user_data/data_source/hive_user_data_data_source.dart';
import 'package:logpass_me/data/user_data/dto/address_dto.dart';
import 'package:logpass_me/data/user_data/dto/email_dto.dart';
import 'package:logpass_me/data/user_data/dto/invoice_dto.dart';
import 'package:logpass_me/data/user_data/dto/personal_data_dto.dart';
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
  UserDataRepository<Address> addressRepository(
          HiveUserDataDataSource<AddressDto> ds, AddressDtoToAddressMapper mapper) =>
      UserAddressDataRepository(ds, mapper);

  UserDataRepository<InvoiceData> invoiceRepository(
          HiveUserDataDataSource<InvoiceDto> ds, InvoiceDtoToInvoiceMapper mapper) =>
      UserInvoiceDataRepository(ds, mapper);

  UserDataRepository<Email> emailRepository(HiveUserDataDataSource<EmailDto> ds, EmailDtoMapper mapper) =>
      UserEmailDataRepository(ds, mapper);

  UserDataRepository<PersonalData> personalDataRepository(
          HiveUserDataDataSource<PersonalDataDto> ds, PersonalDataDtoMapper mapper) =>
      UserPersonalDataRepository(ds, mapper);
}
