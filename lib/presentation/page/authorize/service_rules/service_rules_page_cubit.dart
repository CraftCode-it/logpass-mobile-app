import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/service/data/service_agreement.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'service_rules_page_state.dart';
part 'service_rules_page_cubit.freezed.dart';

@injectable
class ServiceRulesPageCubit extends Cubit<ServiceRulesPageState> {
  late List<ServiceAgreement> _agreements;
  List<ServiceAgreement> get agreements => _agreements;

  ServiceRulesPageCubit() : super(const ServiceRulesPageState.loading());

  void init(List<ServiceAgreement> agreements) {
    _agreements = agreements;
    _emitIdleState();
  }

  void updateAgreements(ServiceAgreement agreement, bool acceptedValue) {
    final updatedAgreement = agreement.copyWith(isAccepted: acceptedValue);
    _agreements = _agreements.map((e) => (e.id == agreement.id) ? updatedAgreement : e).toList();
  }

  void _emitIdleState() {
    final requiredAgreements = _agreements.where((e) => e.isRequired).toList();
    final optionalAgreements = _agreements.where((e) => !e.isRequired).toList();

    emit(ServiceRulesPageState.idle(requiredAgreements, optionalAgreements));
  }
}
