import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/event_log/event_log.dart';
import 'package:logpass_me/domain/event_log/use_case/get_page_of_event_logs_use_case.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/presentation/page/event_log/event_log_page_state.dart';

@injectable
class EventLogPageCubit extends Cubit<EventLogPageState> {
  final GetPageOfEventLogsUseCase _getPageOfEventLogsUseCase;

  int _itemsCount = 0;
  int _currentPage = 0;
  bool _loadedAll = false;
  List<EventLog> _eventLogs = [];

  EventLogPageCubit(this._getPageOfEventLogsUseCase) : super(EventLogPageState.loading());

  Future<void> initialize() async {
    await loadFirstPage();
  }

  Future<void> loadFirstPage() async {
    emit(EventLogPageState.loading());

    _itemsCount = 0;
    _currentPage = 0;
    _loadedAll = false;
    _eventLogs = [];

    try {
      final eventLogBundle = await _getPageOfEventLogsUseCase(1);

      if (eventLogBundle.totalCount == 0) {
        emit(EventLogPageState.empty());
        return;
      }

      _itemsCount += eventLogBundle.eventLogList.length;
      _eventLogs = eventLogBundle.eventLogList;

      emit(EventLogPageState.idle(_eventLogs, false));

      _currentPage++;
    } on GeneralConnectionError catch (e) {
      emit(EventLogPageState.connectionError(e));
      emit(EventLogPageState.empty());
    } catch (e, s) {
      Fimber.e('Fetching EventLog list failed', ex: e, stacktrace: s);
      emit(EventLogPageState.empty());
    }
  }

  Future<void> loadNextPage() async {
    final isLoading = state.maybeMap(
      idle: (state) => state.loadingMore,
      orElse: () => false,
    );

    if (_loadedAll || _currentPage == 0 || isLoading) return;

    emit(EventLogPageState.idle(_eventLogs, true));

    _currentPage++;

    try {
      final eventLogBundle = await _getPageOfEventLogsUseCase(_currentPage);

      _itemsCount += eventLogBundle.eventLogList.length;
      final eventLogs = eventLogBundle.eventLogList;

      _eventLogs = List.from(_eventLogs)..addAll(eventLogs);
      _loadedAll = eventLogBundle.totalCount <= _itemsCount;

      emit(EventLogPageState.idle(_eventLogs, false));
    } on GeneralConnectionError catch (e) {
      emit(EventLogPageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Fetching EventLog list failed', ex: e, stacktrace: s);
      emit(EventLogPageState.empty());
    }
  }
}
