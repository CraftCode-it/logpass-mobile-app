import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_safer_page_state.freezed.dart';

@freezed
class GetSaferPageState with _$GetSaferPageState {
  factory GetSaferPageState.loading() = _GetSaferPageStateLoading;

  factory GetSaferPageState.idle(bool withBiometrics) = _GetSaferPageStateIdle;
}
