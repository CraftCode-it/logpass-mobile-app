import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/database/database_configuration.dart';
import 'package:logpass_me/domain/app_security/app_security_store.dart';
import 'package:logpass_me/domain/auth/auth_store.dart';
import 'package:logpass_me/domain/common/clearable.dart';
import 'package:logpass_me/domain/crypto/crypto_repository.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_actions_repository.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device_store.dart';
import 'package:logpass_me/data/user_data/dto/address_dto.dart';
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
  Future<Box<AddressDto>> dashboardsBox(CryptoRepository cryptoRepository) async {
    final base64Key = await cryptoRepository.getPublicKeyAsBase64();
    final List<int> key = base64Url.decode(base64Key);

    return Hive.openBox<AddressDto>(DatabaseConfiguration.ADDRESSES_BOX, encryptionCipher: HiveAesCipher(key));
  }
}
