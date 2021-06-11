import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/presentation/page/service_details/session_list/session_list_view_state.dart';

@Injectable()
class SessionListViewCubit extends Cubit<SessionListViewState> {
  late Service _service;

  SessionListViewCubit() : super(SessionListViewState.loading());

  Future<void> initialize(Service service) async {
    _service = service;
  }
}
