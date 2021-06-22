import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/domain/service/use_case/get_service_details_use_case.dart';
import 'package:logpass_me/presentation/page/service_details/service_details_page_state.dart';

@Injectable()
class ServiceDetailsPageCubit extends Cubit<ServiceDetailsPageState> {
  final GetServiceDetailsUseCase _getServiceDetailsUseCase;

  late Service _service;

  ServiceDetailsPageCubit(this._getServiceDetailsUseCase) : super(ServiceDetailsPageState.initializing());

  void initialize(Service service) {
    _service = service;
    emit(ServiceDetailsPageState.idle(_service));
  }

  Future<void> refreshServiceData() async {
    emit(ServiceDetailsPageState.processing(_service));

    try {
      _service = await _getServiceDetailsUseCase(_service.clientId);
    } on GeneralConnectionError catch (e) {
      emit(ServiceDetailsPageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Refreshing service details failed', ex: e, stacktrace: s);
      emit(ServiceDetailsPageState.connectionError(GeneralConnectionError.somethingWentWrong()));
    } finally {
      emit(ServiceDetailsPageState.idle(_service));
    }
  }
}
