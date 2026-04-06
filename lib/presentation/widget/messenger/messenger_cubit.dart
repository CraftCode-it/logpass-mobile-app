import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/subscribe_to_incoming_actions_use_case.dart';
import 'package:logpass_me/presentation/widget/messenger/messenger_state.dart';

const _messageDuration = Duration(seconds: 5);

@injectable
class MessengerCubit extends Cubit<MessengerState> {
  final SubscribeToIncomingActionsUseCase _subscribeToIncomingActionsUseCase;

  Timer? _timer;
  StreamSubscription? _actionSubscription;

  MessengerCubit(this._subscribeToIncomingActionsUseCase) : super(MessengerState.idle());

  @override
  Future<void> close() async {
    _timer?.cancel();
    await _actionSubscription?.cancel();
    return super.close();
  }

  void initialize(bool handleActions) {
    if (handleActions) {
      _actionSubscription = _subscribeToIncomingActionsUseCase().listen((event) {
        emit(MessengerState.action(event));
        _setupTimer();
      });
    }
  }

  void showInfo(String message, String? action, Function()? onAction) {
    final state = MessengerState.info(message, action, onAction);
    emit(state);
    _setupTimer();
  }

  void showError(String message) {
    final state = MessengerState.error(message);
    emit(state);
    _setupTimer();
  }

  void dismissCurrent() {
    emit(MessengerState.idle());
  }

  void _setupTimer() {
    _timer?.cancel();
    _timer = Timer(_messageDuration, () {
      emit(MessengerState.idle());
    });
  }
}
