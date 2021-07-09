import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/device/device.dart';
import 'package:logpass_me/domain/device/use_case/get_device_list_use_case.dart';
import 'package:logpass_me/domain/device/use_case/subscribe_to_device_confirmation_use_case.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'trust_level_confirmation_page_state.dart';
part 'trust_level_confirmation_page_cubit.freezed.dart';

@injectable
class TrustLevelConfirmationPageCubit extends Cubit<TrustLevelConfirmationPageState> {
  final GetDeviceListUseCase _getDeviceListUseCase;
  final SubscribeToDeviceConfirmationUseCase _subscribeToDeviceConfirmationUseCase;

  List<Device> _availableDevices = [];
  List<Device> _unavailableDevices = [];

  late int _currentTrustLevel;
  late int _requiredTrustLevel;

  // TODO: fix after backend implementation
  StreamSubscription<Object>? _streamSubscription;

  TrustLevelConfirmationPageCubit(
    this._getDeviceListUseCase,
    this._subscribeToDeviceConfirmationUseCase,
  ) : super(const TrustLevelConfirmationPageState.loading());

  Future<void> init(int initialTrustLevel, int requiredTrustLevel) async {
    _currentTrustLevel = initialTrustLevel;
    _requiredTrustLevel = requiredTrustLevel;

    await _loadDevices();
    _subscribeToDeviceConfirmation();
    _emitIdleState();
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }

  void _subscribeToDeviceConfirmation() {
    try {
      _streamSubscription = _subscribeToDeviceConfirmationUseCase().listen((event) {
        // TODO: update trust level and available devices list
      });
    } catch (e, s) {
      Fimber.e('Failed with device confirmation subscription', ex: e, stacktrace: s);

      emit(const TrustLevelConfirmationPageState.error());
    }
  }

  Future<void> _loadDevices() async {
    try {
      final devices = await _getDeviceListUseCase();
      _availableDevices = List.from(devices);
    } on GeneralConnectionError catch (e) {
      emit(TrustLevelConfirmationPageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Failed to load devices', ex: e, stacktrace: s);
      emit(const TrustLevelConfirmationPageState.error());
    }
  }

  void _emitIdleState() {
    emit(TrustLevelConfirmationPageState.idle(
      _currentTrustLevel,
      _requiredTrustLevel,
      _availableDevices,
      _unavailableDevices,
    ));
  }
}
