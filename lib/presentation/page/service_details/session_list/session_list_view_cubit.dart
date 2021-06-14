import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/domain/service/use_case/get_page_of_service_sessions_use_case.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_list_view_state.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_with_state.dart';

@Injectable()
class SessionListViewCubit extends Cubit<SessionListViewState> {
  final GetPageOfServiceSessionsUseCase _getPageOfServiceSessionsUseCase;

  late bool _activeSessions;
  late Service _service;
  List<SessionWithState> _sessionsWithState = [];
  int _currentPage = 0;
  bool _loadedAll = false;

  SessionListViewCubit(
    this._getPageOfServiceSessionsUseCase,
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
        _currentPage,
        _service.clientId,
        _activeSessions,
      );

      if (sessions.totalCount > 0) {
        _sessionsWithState = sessions.sessions.map((e) => SessionWithState(e, false, false)).toList();
        _loadedAll = _sessionsWithState.length >= sessions.totalCount;
        _currentPage++;

        emit(SessionListViewState.idle(_sessionsWithState, false, _activeSessions));
      } else {
        emit(SessionListViewState.empty());
      }
    } on GeneralConnectionError catch (e) {
      emit(SessionListViewState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Failed to load service sessions', ex: e, stacktrace: s);
    }
  }

  void changeExpanded(int index, bool expanded) {
    final updatedSession = _sessionsWithState[index].copyWith(expanded: expanded);
    final newList = List<SessionWithState>.from(_sessionsWithState);
    newList[index] = updatedSession;

    _sessionsWithState = newList;

    emit(SessionListViewState.idle(newList, false, _activeSessions));
  }
}
