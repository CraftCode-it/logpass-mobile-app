import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_list_page_state.freezed.dart';

@freezed
class ServiceListPageState with _$ServiceListPageState {
  factory ServiceListPageState.loading() = _ServiceListPageStateLoading;

  factory ServiceListPageState.idle() = _ServiceListPageStateIdle;

  factory ServiceListPageState.connectionError() = _ServiceListPageStateConnectionError;
}
