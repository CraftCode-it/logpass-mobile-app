import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/one_time_code/one_time_code.dart';
import 'package:logpass_me/domain/one_time_code/use_case/load_one_time_code.dart';
import 'package:logpass_me/domain/one_time_code/use_case/subscribe_to_one_time_code_use_case.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'one_time_code_container_state.dart';
part 'one_time_code_container_cubit.freezed.dart';

@injectable
class OneTimeCodeContainerCubit extends Cubit<OneTimeCodeContainerState> {
  final LoadOneTimeCodeUseCase _loadOneTimeCodeUseCase;
  final SubscribeToOnetimeCodeUseCase _subscribeToOneTimeCodeUseCase;

  late StreamSubscription<OneTimeCode?> _oneTimeCodeSubscription;
  late OneTimeCode _oneTimeCode;
  Timer? _timer;

  OneTimeCodeContainerCubit(
    this._loadOneTimeCodeUseCase,
    this._subscribeToOneTimeCodeUseCase,
  ) : super(const OneTimeCodeContainerState.loadInProgress());

  Future init() async {
    await refreshOneTimeCode();

    _listenForOneTimeCode();
  }

  void _listenForOneTimeCode() {
    _oneTimeCodeSubscription = _subscribeToOneTimeCodeUseCase().listen(_onCodeChange);
  }

  void _runTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_oneTimeCode.isExpired) {
          refreshOneTimeCode();
        } else {
          _emitIdleState();
        }
      },
    );
  }

  void _onCodeChange(OneTimeCode? oneTimeCode) {
    if (oneTimeCode != null) {
      _oneTimeCode = oneTimeCode;
      _runTimer();
    } else {
      Fimber.e('OneTimeCode is null');

      emit(const OneTimeCodeContainerState.error());
    }
  }

  Future copyOneTimeCodeToClipboard() async {
    await Clipboard.setData(ClipboardData(text: _oneTimeCode.code));
  }

  Future refreshOneTimeCode() async {
    try {
      _timer?.cancel();
      emit(const OneTimeCodeContainerState.loadInProgress());

      await _loadOneTimeCodeUseCase.call(forceRefresh: true);
    } catch (e, s) {
      Fimber.e('Error with OneTimeCode refresh', ex: e, stacktrace: s);

      emit(const OneTimeCodeContainerState.error());
    }
  }

  void _emitIdleState() {
    emit(OneTimeCodeContainerState.idle(_oneTimeCode, _getRemainingTime()));
  }

  double _getRemainingTime() {
    if (_oneTimeCode.isExpired) return 0.0;

    final currentDuration = DateTime.now().difference(_oneTimeCode.expirationTime);
    final ratio = currentDuration.inMilliseconds / _oneTimeCode.expirationSec.inMilliseconds;

    return ratio.abs();
  }

  @override
  Future<void> close() {
    _oneTimeCodeSubscription.cancel();
    _timer?.cancel();
    return super.close();
  }
}
