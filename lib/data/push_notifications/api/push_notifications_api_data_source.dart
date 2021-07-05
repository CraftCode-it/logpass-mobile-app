import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/networking/log_pass_dio.dart';
import 'package:logpass_me/data/push_notifications/api/dto/push_notification_device_dto.dart';
import 'package:logpass_me/data/push_notifications/api/dto/register_push_notification_device_dto.dart';
import 'package:logpass_me/data/push_notifications/api/dto/update_push_notification_device_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'push_notifications_api_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class PushNotificationsApiDataSource {
  @factoryMethod
  factory PushNotificationsApiDataSource(LogPassDio dio) = _PushNotificationsApiDataSource;

  @POST('/push-notifications/devices/')
  Future<PushNotificationDeviceDTO> registerDevice(@Body() RegisterPushNotificationDeviceDTO body);

  @PUT('/push-notifications/devices/{token}/')
  Future<PushNotificationDeviceDTO> updateDevice(@Path() String token, @Body() UpdatePushNotificationDeviceDTO body);

  @DELETE('/push-notifications/devices/{token}/')
  Future<void> unregisterDevice(@Path() String token);
}
