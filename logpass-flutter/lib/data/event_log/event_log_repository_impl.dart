import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/event_log/api/event_log_api_data_source.dart';
import 'package:logpass_me/data/event_log/mapper/event_log_bundle_dto_mapper.dart';
import 'package:logpass_me/data/networking/error/dio_error_resolver.dart';
import 'package:logpass_me/domain/event_log/event_log_bundle.dart';
import 'package:logpass_me/domain/event_log/event_log_repository.dart';

@LazySingleton(as: EventLogRepository)
class EventLogRepositoryImpl implements EventLogRepository {
  final EventLogApiDataSource _eventLogApiDataSource;
  final EventLogBundleDTOMapper _eventLogDTOMapper;

  EventLogRepositoryImpl(this._eventLogApiDataSource, this._eventLogDTOMapper);

  @override
  Future<EventLogBundle> getPageOfEventLogs(int page) async {
    final responseDTO = await callWithDioErrorResolver(() =>
        _eventLogApiDataSource.getEventLogList(page));

    final eventLogBundle = _eventLogDTOMapper(responseDTO);
    return eventLogBundle;
  }

}