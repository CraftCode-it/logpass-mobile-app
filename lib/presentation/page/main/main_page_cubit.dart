import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/get_queued_incoming_action_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/subscribe_to_incoming_actions_from_background_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/subscribe_to_incoming_actions_from_link_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/switch_pre_login_action_handler_use_case.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/push_notifications/use_case/init_notifications_services_use_case.dart';
import 'package:logpass_me/domain/push_notifications/use_case/mark_firebase_notification_as_received_use_case.dart';
import 'package:logpass_me/domain/push_notifications/use_case/register_push_notification_device_use_case.dart';
import 'package:logpass_me/domain/web_socket/use_case/close_web_socket_use_case.dart';
import 'package:logpass_me/domain/web_socket/use_case/setup_web_socket_channel_use_case.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'main_page_cubit.freezed.dart';

part 'main_page_state.dart';

@injectable
class MainPageCubit extends Cubit<MainPageState> {
  final SetupWebSocketChannelUseCase _setupWebSocketChannelUseCase;
  final CloseWebSocketUseCase _closeWebSocketUseCase;
  final InitNotificationsServicesUseCase _initNotificationsServicesUseCase;
  final SwitchPreLoginActionHandlerUseCase _switchPreLoginActionHandlerUseCase;
  final SubscribeToIncomingActionsFromLinkUseCase _subscribeToIncomingActionsFromLinkUseCase;
  final SubscribeToIncomingActionsFromBackgroundUseCase _subscribeToIncomingActionsFromBackgroundUseCase;
  final GetQueuedIncomingActionUseCase _getQueuedIncomingActionUseCase;
  final RegisterPushNotificationDeviceUseCase _registerPushNotificationDeviceUseCase;
  final MarkFirebaseNotificationAsReceivedUseCase _markFirebaseNotificationAsReceivedUseCase;

  StreamSubscription<IncomingAction>? _incomingActionsFromLinkSubscription;
  StreamSubscription<IncomingAction>? _incomingActionsFromBackgroundSubscription;
  StreamSubscription<IncomingAction>? _incomingActionsSubscription;

  MainPageCubit(
    this._setupWebSocketChannelUseCase,
    this._closeWebSocketUseCase,
    this._initNotificationsServicesUseCase,
    this._switchPreLoginActionHandlerUseCase,
    this._subscribeToIncomingActionsFromLinkUseCase,
    this._getQueuedIncomingActionUseCase,
    this._registerPushNotificationDeviceUseCase,
    this._subscribeToIncomingActionsFromBackgroundUseCase,
    this._markFirebaseNotificationAsReceivedUseCase,
  ) : super(const MainPageState.idle());

  Future<void> init() async {
    await _openWebSocketChannelConnection();
    await _initNotificationsServices();
    await _initializeActionHandlers();

    await _registerPushNotificationDeviceUseCase();
  }

  Future<void> _initializeActionHandlers() async {
    await _switchPreLoginActionHandlerUseCase(false);
    await _handleQueuedAction();

    _subscribeToIncomingActions();
  }

  void _subscribeToIncomingActions() {
    _incomingActionsFromLinkSubscription = _subscribeToIncomingActionsFromLinkUseCase().listen((event) {
      emit(MainPageState.openAction(event));
    });
    _incomingActionsFromBackgroundSubscription = _subscribeToIncomingActionsFromBackgroundUseCase().listen((event) {
      _markNotificationAsReceived(event);
      emit(MainPageState.openAction(event));
    });
  }

  Future<void> _handleQueuedAction() async {
    final queuedAction = await _getQueuedIncomingActionUseCase();
    if (queuedAction != null) {
      emit(MainPageState.openAction(queuedAction));
      await _markNotificationAsReceived(queuedAction);
    }
  }

  Future<void> _initNotificationsServices() async {
    try {
      await _initNotificationsServicesUseCase();
    } catch (e, s) {
      Fimber.e('Notification services init failed', ex: e, stacktrace: s);

      emit(const MainPageState.error('Error message'));
    }
  }

  Future<void> _markNotificationAsReceived(IncomingAction incomingAction) async {
    if(incomingAction.actionId != null) {
      try {
        await _markFirebaseNotificationAsReceivedUseCase(incomingAction.actionId!);
      } on GeneralConnectionError catch (e) {
        Fimber.e('No connection', ex: e);
      } catch (e, s) {
        Fimber.e('Mark notification failed', ex: e, stacktrace: s);
      }
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
  Future<void> close() async {
    await _incomingActionsFromLinkSubscription?.cancel();
    await _incomingActionsSubscription?.cancel();
    await _incomingActionsFromBackgroundSubscription?.cancel();
    await _switchPreLoginActionHandlerUseCase(true);
    _closeWebSocketChannel();
    return super.close();
  }
}
