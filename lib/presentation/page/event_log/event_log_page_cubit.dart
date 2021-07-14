import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/event_log/use_case/get_past_events_use_case.dart';
import 'package:logpass_me/presentation/page/event_log/event_log_page_state.dart';

@injectable
class EventLogPageCubit extends Cubit<EventLogPageState> {
  final GetPastEventsUseCase _getPastEventsUseCase;

  EventLogPageCubit(this._getPastEventsUseCase) : super(EventLogPageState.loading());

  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    await load();
  }

  Future<void> load() async {
    emit(EventLogPageState.loading());

    final pastEvents = await _getPastEventsUseCase();

    emit(EventLogPageState.idle(pastEvents));
  }
}
