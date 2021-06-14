import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/presentation/page/service_details/service_details_page_state.dart';

@Injectable()
class ServiceDetailsPageCubit extends Cubit<ServiceDetailsPageState> {
  late Service _service;

  ServiceDetailsPageCubit() : super(ServiceDetailsPageState.initializing());

  void initialize(Service service) {
    _service = service;
    emit(ServiceDetailsPageState.idle(_service));
  }

  Future<void> endAllSessions() async {
    emit(ServiceDetailsPageState.endingAllSessions(_service));
    await Future.delayed(const Duration(seconds: 2));
    emit(ServiceDetailsPageState.idle(_service));
  }
}
