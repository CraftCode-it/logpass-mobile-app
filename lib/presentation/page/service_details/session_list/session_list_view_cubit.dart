import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/data_changed_notifier/data_changed_type.dart';
import 'package:logpass_me/domain/data_changed_notifier/use_case/notify_data_changed_use_case.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/domain/service/use_case/end_sessions_use_case.dart';
import 'package:logpass_me/domain/service/use_case/get_page_of_service_sessions_use_case.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_list_view_state.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_with_state.dart';

@Injectable()
class SessionListViewCubit extends Cubit<SessionListViewState> {
  final GetPageOfServiceSessionsUseCase _getPageOfServiceSessionsUseCase;
  final EndSessionUseCase _endSessionUseCase;
  final NotifyDataChangedUseCase _notifyDataChangedUseCase;

  late bool _activeSessions;
  late Service _service;
  List<SessionWithState> _sessionsWithState = [];
  int _currentPage = 0;
  bool _loadedAll = false;
  bool _loadingMore = false;

  SessionListViewCubit(
    this._getPageOfServiceSessionsUseCase,
    this._endSessionUseCase,
    this._notifyDataChangedUseCase,
  ) : super(SessionListViewState.loading());

  Future<void> initialize(bool active, Service service) async {
    _activeSessions = active;
    _service = service;
    await loadFirstPage();
  }

  Future<void> loadFirstPage() async {
    emit(SessionListViewState.loading());

    _sessionsWithState = [];
    _currentPage = 0;
    _loadedAll = false;

    try {
      final sessions = await _getPageOfServiceSessionsUseCase(
        1,
        _service.clientId,
        _activeSessions,
      );

      if (sessions.totalCount > 0) {
        _sessionsWithState = sessions.sessions.map((e) => SessionWithState(e, false, false)).toList();
        _loadedAll = _sessionsWithState.length >= sessions.totalCount;
        _currentPage++;

        emit(SessionListViewState.idle(_sessionsWithState, false, _activeSessions));
      } else {
        emit(SessionListViewState.empty(_activeSessions));
      }
    } on GeneralConnectionError catch (e) {
      emit(SessionListViewState.connectionError(e));
      emit(SessionListViewState.empty(_activeSessions));
    } catch (e, s) {
      Fimber.e('Failed to load service sessions', ex: e, stacktrace: s);
      emit(SessionListViewState.empty(_activeSessions));
    }
  }

  Future<void> loadNextPage() async {
    if (_loadedAll || _currentPage == 0 || _loadingMore) return;

    _loadingMore = true;
    emit(SessionListViewState.idle(_sessionsWithState, true, _activeSessions));
    _currentPage++;

    try {
      final services = await _getPageOfServiceSessionsUseCase(
        _currentPage,
        _service.clientId,
        _activeSessions,
      );

      final newSessions = services.sessions.map((e) => SessionWithState(e, false, false)).toList();

      _sessionsWithState = List.from(_sessionsWithState)..addAll(newSessions);
      _loadedAll = services.totalCount <= _sessionsWithState.length;

      emit(SessionListViewState.idle(_sessionsWithState, false, _activeSessions));
    } on GeneralConnectionError catch (e) {
      emit(SessionListViewState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Fetching service list failed', ex: e, stacktrace: s);
      emit(SessionListViewState.idle(_sessionsWithState, false, _activeSessions));
    } finally {
      _loadingMore = false;
    }
  }

  Future<void> endSession(SessionWithState session) async {
    final sessionToEnd = _sessionsWithState.firstWhere((element) => element.session.id == session.session.id);
    final endingSession = sessionToEnd.copyWith(endingSessionInProgress: true);

    try {
      _emitIdleWithUpdatedSession(endingSession);
      await _endSessionUseCase(endingSession.session);

      final newList = List<SessionWithState>.from(_sessionsWithState);
      newList.removeWhere((element) => element.session.id == endingSession.session.id);
      _sessionsWithState = newList;

      emit(SessionListViewState.endedSession());

      await _notifyDataChangedUseCase(DataChangedType.service);

      if (newList.isEmpty) {
        emit(SessionListViewState.empty(_activeSessions));
      } else {
        emit(SessionListViewState.idle(newList, false, _activeSessions));
      }
    } on GeneralConnectionError catch (e) {
      emit(SessionListViewState.connectionError(e));
      _emitIdleWithUpdatedSession(sessionToEnd);
    } catch (e, s) {
      Fimber.e('Failed to end session', ex: e, stacktrace: s);
      _emitIdleWithUpdatedSession(sessionToEnd);
    }
  }

  void changeExpanded(int index, bool expanded) {
    final updatedSession = _sessionsWithState[index].copyWith(expanded: expanded);
    final newList = List<SessionWithState>.from(_sessionsWithState);
    newList[index] = updatedSession;

    _sessionsWithState = newList;

    emit(SessionListViewState.idle(newList, false, _activeSessions));
  }

  void _emitIdleWithUpdatedSession(SessionWithState updatedSession) {
    final newList = List<SessionWithState>.from(_sessionsWithState);
    final index = newList.indexWhere((element) => element.session.id == updatedSession.session.id);

    if (index != -1) {
      newList[index] = updatedSession;
      _sessionsWithState = newList;
      emit(SessionListViewState.idle(newList, _loadingMore, _activeSessions));
    }
  }
}
