import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app_security/app_security_store.dart';
import 'package:logpass_me/domain/auth/auth_store.dart';
import 'package:logpass_me/domain/common/clearable.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_with_splitted_actions_repository.dart';
import 'package:logpass_me/domain/push_notifications/push_notification_device_store.dart';
import 'package:logpass_me/domain/user_data/phone_number_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class StorageModule {
  @preResolve
  Future<SharedPreferences> getSharedPreferences() => SharedPreferences.getInstance();

  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  List<Clearable> clearables(
    IncomingWithSplittedActionsRepository incomingWithSplittedActionsRepository,
    AppSecurityStore appSecurityStore,
    AuthStore authStore,
    PushNotificationDeviceStore pushNotificationDeviceStore,
    PhoneNumberStore phoneNumberStore,
  ) =>
      [
        incomingWithSplittedActionsRepository,
        appSecurityStore,
        authStore,
        pushNotificationDeviceStore,
        phoneNumberStore,
      ];
}
