import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/internet_connection/use_case/dispose_internet_connection_use_case.dart';
import 'package:logpass_me/domain/internet_connection/use_case/get_internet_connection_use_case.dart';
import 'package:logpass_me/domain/internet_connection/use_case/listen_internet_connection_use_case.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/one_time_code/one_time_code.dart';
import 'package:logpass_me/domain/one_time_code/use_case/load_one_time_code_use_case.dart';
import 'package:logpass_me/domain/one_time_code/use_case/subscribe_to_one_time_code_use_case.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'one_time_code_container_state.dart';
part 'one_time_code_container_cubit.freezed.dart';

@injectable
class OneTimeCodeContainerCubit extends Cubit<OneTimeCodeContainerState> {
  final LoadOneTimeCodeUseCase _loadOneTimeCodeUseCase;
  final SubscribeToOnetimeCodeUseCase _subscribeToOneTimeCodeUseCase;
  final GetInternetConnectionUseCase _getInternetConnectionUseCase;
  final ListenInternetConnectionUseCase _listenInternetConnectionUseCase;
  final DisposeInternetConnectionUseCase _disposeInternetConnectionUseCase;

  StreamSubscription<OneTimeCode?>? _oneTimeCodeSubscription;
  StreamSubscription<bool>? _internetSubscription;
  OneTimeCode? _oneTimeCode;
  bool _hasInternetConnection = true;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  OneTimeCodeContainerCubit(
    this._loadOneTimeCodeUseCase,
    this._subscribeToOneTimeCodeUseCase,
    this._getInternetConnectionUseCase,
    this._listenInternetConnectionUseCase,
    this._disposeInternetConnectionUseCase,
  ) : super(const OneTimeCodeContainerState.loadInProgress());

  Future init() async {
    _hasInternetConnection = await _getInternetConnectionUseCase();
    await refreshOneTimeCode();

    _listenForOneTimeCode();
    _listenInternetConnection();
  }

  void _listenForOneTimeCode() {
    try {
      _oneTimeCodeSubscription = _subscribeToOneTimeCodeUseCase().listen(_onCodeChange);
    } catch (e, s) {
      Fimber.e('Error with OneTimeCode subscriber', ex: e, stacktrace: s);

      emit(const OneTimeCodeContainerState.error());
    }
  }

  void _onCodeChange(OneTimeCode? oneTimeCode) {
    if (oneTimeCode != null) {
      _oneTimeCode = oneTimeCode;
      _emitIdleState();
    } else {
      Fimber.e('OneTimeCode is null');

      emit(const OneTimeCodeContainerState.error());
    }
  }

  Future copyOneTimeCodeToClipboard() async {
    final code = _oneTimeCode;
    if (code == null) return;
    await Clipboard.setData(ClipboardData(text: code.code));
  }

  Future refreshOneTimeCode() async {
    try {
      emit(const OneTimeCodeContainerState.loadInProgress());

      await _loadOneTimeCodeUseCase.call();
      _retryCount = 0;
    } on GeneralConnectionError catch (e) {
      emit(OneTimeCodeContainerState.connectionError(e));
      emit(OneTimeCodeContainerState.internetConnection(_hasInternetConnection));
      _scheduleRetry();
    } catch (e, s) {
      Fimber.e('Error with OneTimeCode refresh', ex: e, stacktrace: s);

      emit(const OneTimeCodeContainerState.error());
      _scheduleRetry();
    }
  }

  void _scheduleRetry() {
    if (_retryCount < _maxRetries) {
      _retryCount++;
      Future.delayed(const Duration(seconds: 5), () {
        if (!isClosed) refreshOneTimeCode();
      });
    }
  }

  void _emitIdleState() {
    final code = _oneTimeCode;
    if (code == null) return;
    emit(OneTimeCodeContainerState.idle(code));
  }

  @override
  Future<void> close() async {
    await _disposeInternetConnectionUseCase();
    await _oneTimeCodeSubscription?.cancel();
    await _internetSubscription?.cancel();
    return super.close();
  }

  void _listenInternetConnection() {
    _internetSubscription = _listenInternetConnectionUseCase().listen((hasConnection) {
      _hasInternetConnection = hasConnection;

      state.maybeWhen(
        error: () => emit(OneTimeCodeContainerState.internetConnection(_hasInternetConnection)),
        internetConnection: (_) =>
            emit(OneTimeCodeContainerState.internetConnection(_hasInternetConnection)),
        orElse: () {},
      );
    });
  }
}
