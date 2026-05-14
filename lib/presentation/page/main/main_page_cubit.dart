import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/get_queued_incoming_action_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/subscribe_refresh_code_actions_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/subscribe_to_incoming_actions_from_background_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/subscribe_to_incoming_actions_from_link_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/switch_pre_login_action_handler_use_case.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/one_time_code/use_case/load_one_time_code_use_case.dart';
import 'package:logpass_me/domain/push_notifications/use_case/init_notifications_services_use_case.dart';
import 'package:logpass_me/domain/push_notifications/use_case/mark_notification_as_received_use_case.dart';
import 'package:logpass_me/domain/push_notifications/use_case/register_push_notification_device_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/subscribe_to_incoming_actions_use_case.dart';
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
  final SubscribeToRefreshCodeActionsUseCase _subscribeToRefreshCodeActionsUseCase;
  final GetQueuedIncomingActionUseCase _getQueuedIncomingActionUseCase;
  final RegisterPushNotificationDeviceUseCase _registerPushNotificationDeviceUseCase;
  final LoadOneTimeCodeUseCase _loadOneTimeCodeUseCase;
  final MarkNotificationAsReceivedUseCase _markNotificationAsReceivedUseCase;
  final SubscribeToIncomingActionsUseCase _subscribeToIncomingActionsUseCase;

  StreamSubscription<IncomingAction>? _incomingActionsFromLinkSubscription;
  StreamSubscription<IncomingAction>? _incomingActionsFromBackgroundSubscription;
  StreamSubscription<IncomingAction>? _incomingActionsSubscription;
  StreamSubscription<IncomingAction>? _refreshCodeSubscription;

  MainPageCubit(
    this._setupWebSocketChannelUseCase,
    this._closeWebSocketUseCase,
    this._initNotificationsServicesUseCase,
    this._switchPreLoginActionHandlerUseCase,
    this._subscribeToIncomingActionsFromLinkUseCase,
    this._getQueuedIncomingActionUseCase,
    this._registerPushNotificationDeviceUseCase,
    this._subscribeToIncomingActionsFromBackgroundUseCase,
    this._subscribeToRefreshCodeActionsUseCase,
    this._loadOneTimeCodeUseCase,
    this._markNotificationAsReceivedUseCase,
    this._subscribeToIncomingActionsUseCase,
  ) : super(const MainPageState.idle());

  Future<void> init() async {
    try {
      await _registerPushNotificationDeviceUseCase();
    } catch (e, s) {
      Fimber.e('Push device registration failed (WS will use fallback URL)', ex: e, stacktrace: s);
    }

    _subscribeToRefreshCode();
    await _initNotificationsServices();
    await _openWebSocketChannelConnection();
    await _initializeActionHandlers();
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
      emit(MainPageState.openAction(event));
    });
    // Subscribe to WS-based push actions (logpass_verify)
    _incomingActionsSubscription = _subscribeToIncomingActionsUseCase().listen((event) {
      emit(MainPageState.openAction(event));
    });
  }

  Future<void> _handleQueuedAction() async {
    final queuedAction = await _getQueuedIncomingActionUseCase();
    if (queuedAction != null) {
      emit(MainPageState.openAction(queuedAction));
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
    await _refreshCodeSubscription?.cancel();
    await _switchPreLoginActionHandlerUseCase(true);
    _closeWebSocketChannel();
    return super.close();
  }

  void _subscribeToRefreshCode() {
    _refreshCodeSubscription = _subscribeToRefreshCodeActionsUseCase().listen((action) async {
      await _markAsReceived(action);
      await _refreshUserCode();
    });
  }

  Future<void> _markAsReceived(IncomingAction incomingAction) async {
    try {
      await _markNotificationAsReceivedUseCase(incomingAction);
    } on GeneralConnectionError catch (e) {
      Fimber.e('There is problem with internet connection', ex: e);
    } catch (e, s) {
      Fimber.e('Failed to marking notification as received', ex: e, stacktrace: s);
    }
  }

  Future<void> _refreshUserCode() async {
    try {
      await _loadOneTimeCodeUseCase();
    } on GeneralConnectionError catch (e) {
      Fimber.e('There is problem with internet connection', ex: e);
    } catch (e, s) {
      Fimber.e('Failed to refresh user code', ex: e, stacktrace: s);
    }
  }
}
