import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/event_log/api/dto/event_log_response_dto.dart';
import 'package:logpass_me/data/networking/log_pass_dio.dart';
import 'package:retrofit/retrofit.dart';

part 'event_log_api_data_source.g.dart';

@LazySingleton()
@RestApi()
abstract class EventLogApiDataSource {
  @factoryMethod
  factory EventLogApiDataSource(LogPassDio dio) = _EventLogApiDataSource;

  @GET('/users/self/logs/')
  Future<EventLogResponseDTO> getEventLogList(@Query('page_number') int page);
}

