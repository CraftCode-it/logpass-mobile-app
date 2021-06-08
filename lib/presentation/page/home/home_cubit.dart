import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  late List<String> _pendingActions;

  HomeCubit() : super(const HomeState.loadInProgress());

  Future init() async {
    // TODO: replace stub with actual implementation
    _getActions();
  }

  Future _getActions() async {
    await Future.delayed(const Duration(seconds: 1));
    _pendingActions = [];
    _emitIdleState();
  }

  void _emitIdleState() {
    emit(HomeState.idle(_pendingActions));
  }
}
