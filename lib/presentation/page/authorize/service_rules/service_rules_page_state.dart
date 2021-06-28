part of 'service_rules_page_cubit.dart';

@freezed
class ServiceRulesPageState with _$ServiceRulesPageState {
  @Implements(BuildState)
  const factory ServiceRulesPageState.loading() = _ServiceRulesPageStateLoading;

  @Implements(BuildState)
  const factory ServiceRulesPageState.idle(
    List<ServiceAgreement> requiredAgreements,
    List<ServiceAgreement> optionAgreements,
  ) = _ServiceRulesPageStateIdle;
}
