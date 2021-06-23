import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/service/data/service_with_tokens.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'service_list_page_state.freezed.dart';

@freezed
class ServiceListPageState with _$ServiceListPageState {
  @Implements(BuildState)
  factory ServiceListPageState.loading() = _ServiceListPageStateLoading;

  @Implements(BuildState)
  factory ServiceListPageState.idle(
    List<ServiceWithTokens> activeServices,
    List<ServiceWithTokens> otherServices,
    bool loadingMore,
  ) = ServiceListPageStateIdle;

  @Implements(BuildState)
  factory ServiceListPageState.empty() = _ServiceListPageStateEmpty;

  factory ServiceListPageState.connectionError(GeneralConnectionError error) = _ServiceListPageStateConnectionError;
}
