import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/presentation/widget/timed_wrapper/timed_wrapper_state.dart';

@Injectable()
class TimedWrapperCubit extends Cubit<TimedWrapperState> {
  static const Duration _interval = Duration(seconds: 1);

  late DateTime _timestamp;
  StreamSubscription? _timerSubscription;

  TimedWrapperCubit() : super(TimedWrapperState.loading());

  @override
  Future<void> close() {
    _timerSubscription?.cancel();
    return super.close();
  }

  void initialize(DateTime timestamp) {
    _timestamp = timestamp;

    final initialState = _calculateCurrentState();
    emit(initialState);

    if (initialState == TimedWrapperState.passed()) return;

    _timerSubscription?.cancel();
    _timerSubscription = Stream.periodic(_interval).listen((event) {
      final currentState = _calculateCurrentState();
      emit(currentState);

      currentState.maybeWhen(
        passed: () => _timerSubscription?.cancel(),
        orElse: () {},
      );
    });
  }

  TimedWrapperState _calculateCurrentState() {
    final time = DateTime.now();
    return _timestamp.isAfter(time) ? TimedWrapperState.ongoing() : TimedWrapperState.passed();
  }
}
