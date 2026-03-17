import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'service_details_page_state.freezed.dart';

@freezed
class ServiceDetailsPageState with _$ServiceDetailsPageState {
  @Implements<BuildState>()
  factory ServiceDetailsPageState.initializing() = _ServiceDetailsPageStateInitializing;

  @Implements<BuildState>()
  factory ServiceDetailsPageState.idle(Service service) = ServiceDetailsPageStateIdle;

  @Implements<BuildState>()
  factory ServiceDetailsPageState.processing(Service service) = ServiceDetailsPageStateProcessing;

  factory ServiceDetailsPageState.connectionError(GeneralConnectionError error) = _ServiceDetailsPageStateConnectionError;
}
