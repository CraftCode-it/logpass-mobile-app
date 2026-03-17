import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/common/data_mapper.dart';
import 'package:logpass_me/data/event_log/api/dto/event_log_response_dto.dart';
import 'package:logpass_me/data/event_log/mapper/event_log_dto_mapper.dart';
import 'package:logpass_me/domain/event_log/event_log.dart';
import 'package:logpass_me/domain/event_log/event_log_bundle.dart';
import 'package:logpass_me/domain/event_log/event_type.dart';
import 'package:logpass_me/domain/event_log/logo_type.dart';

@Injectable()
class EventLogBundleDTOMapper implements DataMapper<EventLogResponseDTO, EventLogBundle> {
  final EventLogDTOMapper _eventLogDTOMapper;

  EventLogBundleDTOMapper(this._eventLogDTOMapper);

  @override
  EventLogBundle call(EventLogResponseDTO response) {
    final eventLogList = response.data.map((eventLog) => _eventLogDTOMapper(eventLog)).toList();

    return EventLogBundle(
        response.metadata.totalCount,
        eventLogList
    );
  }
}