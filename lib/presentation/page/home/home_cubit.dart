import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/one_time_code/one_time_code.dart';
import 'package:logpass_me/domain/one_time_code/use_case/load_one_time_code.dart';
import 'package:logpass_me/domain/one_time_code/use_case/subscribe_to_one_time_code_use_case.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final LoadOneTimeCodeUseCase _loadOneTimeCodeUseCase;
  final SubscribeToOnetimeCodeUseCase _subscribeToOneTimeCodeUseCase;

  late StreamSubscription<OneTimeCode?> _oneTimeCodeSubscription;
  late OneTimeCode _oneTimeCode;

  HomeCubit(
    this._loadOneTimeCodeUseCase,
    this._subscribeToOneTimeCodeUseCase,
  ) : super(const HomeState.loadInProgress());

  Future init() async {
    await _loadOneTimeCodeUseCase.call(forceRefresh: true);

    _listenForOneTimeCode();
  }

  void _listenForOneTimeCode() {
    _oneTimeCodeSubscription = _subscribeToOneTimeCodeUseCase().listen(_onCodeChange);
  }

  void _onCodeChange(OneTimeCode? oneTimeCode) {
    if (oneTimeCode != null) {
      _oneTimeCode = oneTimeCode;
      _emitIdleState();
    } else {
      // TODO: handle when oneTimeCode is null
      print('error print: $oneTimeCode');
    }
  }

  void _emitIdleState() {
    emit(HomeState.idle(_oneTimeCode));
  }

  @override
  Future<void> close() {
    _oneTimeCodeSubscription.cancel();
    return super.close();
  }
}
