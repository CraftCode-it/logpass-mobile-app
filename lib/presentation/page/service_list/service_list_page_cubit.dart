import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/domain/service/data/services_bundle.dart';
import 'package:logpass_me/domain/service/use_case/get_page_of_services_use_case.dart';
import 'package:logpass_me/presentation/page/service_list/service_list_page_state.dart';

@Injectable()
class ServiceListPageCubit extends Cubit<ServiceListPageState> {
  final GetPageOfServicesUseCase _getPageOfServicesUseCase;

  bool _loadedAll = false;
  int _currentPage = 0;
  int _itemsCount = 0;
  List<Service> _activeServices = [];
  List<Service> _otherServices = [];

  ServiceListPageCubit(this._getPageOfServicesUseCase) : super(ServiceListPageState.loading());

  Future<void> loadFirstPage() async {
    emit(ServiceListPageState.loading());

    _currentPage = 0;
    _loadedAll = false;

    try {
      final services = await _getPageOfServicesUseCase(1);

      _itemsCount += services.services.length;

      _activeServices = _getActiveServices(services);
      _otherServices = _getOtherServices(services);

      emit(ServiceListPageState.idle(_activeServices, _otherServices, false));

      _currentPage++;
    } on GeneralConnectionError catch (e) {
      emit(ServiceListPageState.connectionError(e));
      emit(ServiceListPageState.empty());
    } catch (e, s) {
      Fimber.e('Fetching service list failed', ex: e, stacktrace: s);
      emit(ServiceListPageState.empty());
    }
  }

  Future<void> loadNextPage() async {
    final isLoading = state.maybeMap(
      idle: (state) => state.loadingMore,
      orElse: () => false,
    );

    if (_loadedAll || _currentPage == 0 || isLoading) return;

    emit(ServiceListPageState.idle(_activeServices, _otherServices, true));

    _currentPage++;

    try {
      final services = await _getPageOfServicesUseCase(_currentPage);

      _itemsCount += services.services.length;

      final active = _getActiveServices(services);
      final other = _getOtherServices(services);

      _activeServices = List.from(_activeServices)..addAll(active);
      _otherServices = List.from(_otherServices)..addAll(other);

      _didLoadAllItems(services);

      emit(ServiceListPageState.idle(_activeServices, _otherServices, false));
    } on GeneralConnectionError catch (e) {
      emit(ServiceListPageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Fetching service list failed', ex: e, stacktrace: s);
      emit(ServiceListPageState.empty());
    }
  }

  List<Service> _getActiveServices(ServicesBundle services) {
    return services.services.where((element) => element.tokens.activeCount != 0).toList(growable: false);
  }

  List<Service> _getOtherServices(ServicesBundle services) {
    return services.services.where((element) => element.tokens.activeCount == 0).toList(growable: false);
  }

  void _didLoadAllItems(ServicesBundle bundle) {
    _loadedAll = bundle.totalCount <= _itemsCount;
  }
}
