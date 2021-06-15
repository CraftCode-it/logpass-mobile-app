import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/subscribe_to_incoming_actions_use_case.dart';
import 'package:logpass_me/domain/push_notifications/use_case/init_notifications_services_use_case.dart';
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
  final InitNotificationsServicesUseCase _initNotificationsServicesUseCase;

  StreamSubscription<IncomingAction>? _streamSubscription;

  MainPageCubit(
    this._setupWebSocketChannelUseCase,
    this._subscribeToIncomingActionsUseCase,
    this._closeWebSocketUseCase,
    this._initNotificationsServicesUseCase,
  ) : super(const MainPageState.idle());

  Future init() async {
    await _openWebSocketChannelConnection();
    await _initNotificationsServices();
    _subscribeToIncomingActions();
  }

  Future _initNotificationsServices() async {
    try {
      await _initNotificationsServicesUseCase();
    } catch (e, s) {
      Fimber.e('Notification services init failed', ex: e, stacktrace: s);

      emit(const MainPageState.error('Error message'));
    }
  }

  void _subscribeToIncomingActions() {
    try {
      _streamSubscription = _subscribeToIncomingActionsUseCase().listen((action) {
        emit(MainPageState.showAction(action));
      });
    } catch (e, s) {
      Fimber.e('Subscription to incoming actions failed', ex: e, stacktrace: s);

      emit(const MainPageState.error('Error message'));
    }
  }

  Future _openWebSocketChannelConnection() async {
    try {
      await _setupWebSocketChannelUseCase();
    } catch (e, s) {
      Fimber.e('Opening WS channel failed', ex: e, stacktrace: s);

      emit(const MainPageState.error('Error message'));
    }
  }

  void _closeWebSocketChannel() {
    try {
      _closeWebSocketUseCase();
    } catch (e, s) {
      Fimber.e('Closing WS channel failed', ex: e, stacktrace: s);
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    _closeWebSocketChannel();
    return super.close();
  }
}
