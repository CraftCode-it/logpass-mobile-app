import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/actions_changed_notifier/use_case/listen_for_actions_change_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/subscribe_to_incoming_actions_from_link_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/subscribe_to_incoming_actions_use_case.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final SubscribeToIncomingActionsUseCase _subscribeToIncomingActionsUseCase;
  final ListenForActionsChangeUseCase _listenForActionsChangeUseCase;
  final SubscribeToIncomingActionsFromLinkUseCase _subscribeToIncomingActionsFromLinkUseCase;
  final List<IncomingAction> _pendingActions = [];

  StreamSubscription<IncomingAction>? _incomingActionSubscription;
  StreamSubscription<IncomingAction>? _incomingActionFromLinkSubscription;
  StreamSubscription<IncomingAction>? _actionsChangedSubscription;

  HomeCubit(
    this._subscribeToIncomingActionsUseCase,
    this._listenForActionsChangeUseCase,
    this._subscribeToIncomingActionsFromLinkUseCase,
  ) : super(const HomeState.loadInProgress());

  Future init() async {
    // TODO: replace stub with actual implementation
    await _getActions();
    _subscribeToIncomingActions();
    _subscribeToIncomingActionsFromLink();
    _subscribeToChangedActionsState();
  }

  void emitCopyInformation() {
    emit(const HomeState.codeCopied());
    _emitIdleState();
  }

  void _subscribeToChangedActionsState() {
    try {
      _actionsChangedSubscription = _listenForActionsChangeUseCase().listen((action) {
        _pendingActions.remove(action);
        _emitIdleState();
      });
    } catch (e, s) {
      Fimber.e('Subscription to changed actions failed', ex: e, stacktrace: s);

      emit(const HomeState.error('Error message'));
    }
  }

  void _subscribeToIncomingActionsFromLink() {
    try {
      _incomingActionFromLinkSubscription = _subscribeToIncomingActionsFromLinkUseCase().listen((action) async {
        // TODO: fetch pending actions from API instead of adding value from stream manually
        _pendingActions.insert(0, action);

        _emitIdleState();
      });
    } catch (e, s) {
      Fimber.e('Subscription to incoming actions from link failed', ex: e, stacktrace: s);

      emit(const HomeState.error('Error message'));
    }
  }

  void _subscribeToIncomingActions() {
    try {
      _incomingActionSubscription = _subscribeToIncomingActionsUseCase().listen((action) async {
        // TODO: fetch pending actions from API instead of adding value from stream manually
        _pendingActions.insert(0, action);

        _emitIdleState();
      });
    } catch (e, s) {
      Fimber.e('Subscription to incoming actions failed', ex: e, stacktrace: s);

      emit(const HomeState.error('Error message'));
    }
  }

  Future _getActions() async {
    emit(const HomeState.loadInProgress());
    await Future.value(const Duration(seconds: 1));

    _emitIdleState();
  }

  void _emitIdleState() {
    emit(HomeState.idle(List.from(_pendingActions)));
  }

  @override
  Future<void> close() {
    _incomingActionSubscription?.cancel();
    _incomingActionFromLinkSubscription?.cancel();
    _actionsChangedSubscription?.cancel();

    return super.close();
  }
}
