import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/incoming_actions/use_case/subscribe_to_incoming_actions_use_case.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final SubscribeToIncomingActionsUseCase _subscribeToIncomingActionsUseCase;
  final List<IncomingAction> _pendingActions = [];

  StreamSubscription<IncomingAction>? _streamSubscription;

  HomeCubit(this._subscribeToIncomingActionsUseCase) : super(const HomeState.loadInProgress());

  Future init() async {
    // TODO: replace stub with actual implementation
    await _getActions();
    _subscribeToIncomingActions();
  }

  void _subscribeToIncomingActions() {
    try {
      _streamSubscription = _subscribeToIncomingActionsUseCase().listen((action) async {
        // TODO: fetch pending actions from API
        _pendingActions.add(action);
        await _getActions();
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
    emit(HomeState.idle(_pendingActions));
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();

    return super.close();
  }
}
