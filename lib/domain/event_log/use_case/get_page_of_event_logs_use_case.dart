import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/event_log/event_log.dart';
import 'package:logpass_me/domain/event_log/event_log_bundle.dart';
import 'package:logpass_me/domain/event_log/event_log_repository.dart';
import 'package:logpass_me/domain/incoming_actions/action_type.dart';

@injectable
class GetPageOfEventLogsUseCase {

  final EventLogRepository _repository;

  GetPageOfEventLogsUseCase(this._repository);

  Future<EventLogBundle> call(int page) =>
      _repository.getPageOfEventLogs(page);
}
