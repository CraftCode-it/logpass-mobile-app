import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/subscribe_to_incoming_actions_use_case.dart';
import 'package:logpass_me/domain/web_socket/use_case/close_web_socket_use_case.dart';
import 'package:logpass_me/domain/web_socket/use_case/setup_web_socket_channel_use_case.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'main_page_state.dart';
part 'main_page_cubit.freezed.dart';

@injectable
class MainPageCubit extends Cubit<MainPageState> {
  final SetupWebSocketChannelUseCase _setupWebSocketChannelUseCase;
  final CloseWebSocketUseCase _closeWebSocketUseCase;
  final SubscribeToIncomingActionsUseCase _subscribeToIncomingActionsUseCase;

  late StreamSubscription<IncomingAction> _streamSubscription;

  MainPageCubit(
    this._setupWebSocketChannelUseCase,
    this._subscribeToIncomingActionsUseCase,
    this._closeWebSocketUseCase,
  ) : super(const MainPageState.loading());

  Future init() async {
    await _setupWebSocketChannelUseCase();
    _subscribeToIncomingActions();

    _emitIdleState();
  }

  void _subscribeToIncomingActions() {
    // TODO: handle incoming actions
    _streamSubscription = _subscribeToIncomingActionsUseCase().listen((action) {
      print('Link: ${action.link}');
    });
  }

  void _emitIdleState() {
    emit(const MainPageState.idle());
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    _closeWebSocketUseCase();
    return super.close();
  }
}
