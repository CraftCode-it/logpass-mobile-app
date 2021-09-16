import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/database/database_configuration.dart';
import 'package:logpass_me/data/user_data/dto/address_dto.dart';
import 'package:logpass_me/data/user_data/dto/email_dto.dart';
import 'package:logpass_me/data/user_data/dto/invoice_dto.dart';
import 'package:logpass_me/data/user_data/dto/personal_data_dto.dart';
import 'package:logpass_me/domain/app_security/app_security_store.dart';
import 'package:logpass_me/domain/auth/auth_store.dart';
import 'package:logpass_me/domain/common/clearable.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_actions_repository.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device_store.dart';
import 'package:logpass_me/domain/user_data/data/personal_data.dart';
import 'package:logpass_me/domain/user_data/phone_number_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class StorageModule {
  @preResolve
  Future<SharedPreferences> getSharedPreferences() => SharedPreferences.getInstance();

  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  List<Clearable> clearables(
    IncomingActionsRepository incomingActionsRepository,
    AppSecurityStore appSecurityStore,
    AuthStore authStore,
    PushNotificationDeviceStore pushNotificationDeviceStore,
    PhoneNumberStore phoneNumberStore,
  ) =>
      [
        incomingActionsRepository,
        appSecurityStore,
        authStore,
        pushNotificationDeviceStore,
        phoneNumberStore,
      ];

  @preResolve
  Future<Box<AddressDto>> dashboardsBox(@Named('encryption_key') List<int> key) async {
    return Hive.openBox<AddressDto>(DatabaseConfiguration.ADDRESSES_BOX, encryptionCipher: HiveAesCipher(key));
  }

  @preResolve
  Future<Box<InvoiceDto>> invoicesBox(@Named('encryption_key') List<int> key) async {
    return Hive.openBox<InvoiceDto>(DatabaseConfiguration.INVOICES_BOX, encryptionCipher: HiveAesCipher(key));
  }

  @preResolve
  Future<Box<EmailDto>> emailsBox(@Named('encryption_key') List<int> key) async {
    return Hive.openBox<EmailDto>(DatabaseConfiguration.EMAILS_BOX, encryptionCipher: HiveAesCipher(key));
  }

  @preResolve
  Future<Box<PersonalDataDto>> personalDataBox(@Named('encryption_key') List<int> key) async {
    return Hive.openBox<PersonalDataDto>(DatabaseConfiguration.PERSONAL_DATA_BOX, encryptionCipher: HiveAesCipher(key));
  }
}
