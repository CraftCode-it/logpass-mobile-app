import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/data_changed_notifier/data_changed_type.dart';
import 'package:logpass_me/domain/data_changed_notifier/use_case/listen_for_data_changed_use_case.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/service/data/service_with_tokens.dart';
import 'package:logpass_me/domain/service/data/services_bundle.dart';
import 'package:logpass_me/domain/service/use_case/get_page_of_services_use_case.dart';
import 'package:logpass_me/presentation/page/service_list/service_list_page_state.dart';

@Injectable()
class ServiceListPageCubit extends Cubit<ServiceListPageState> {
  final GetPageOfServicesUseCase _getPageOfServicesUseCase;
  final ListenForDataChangedUseCase _listenForDataChangedUseCase;

  StreamSubscription? _dataChangedSubscription;

  bool _loadedAll = false;
  int _currentPage = 0;
  int _itemsCount = 0;
  List<ServiceWithTokens> _activeServices = [];
  List<ServiceWithTokens> _otherServices = [];

  ServiceListPageCubit(
    this._getPageOfServicesUseCase,
    this._listenForDataChangedUseCase,
  ) : super(ServiceListPageState.loading());

  @override
  Future<void> close() async {
    await _dataChangedSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    _dataChangedSubscription = _listenForDataChangedUseCase(DataChangedType.service).listen((event) {
      loadFirstPage();
    });

    await loadFirstPage();
  }

  Future<void> loadFirstPage() async {
    emit(ServiceListPageState.loading());

    _itemsCount = 0;
    _currentPage = 0;
    _loadedAll = false;
    _activeServices = [];
    _otherServices = [];

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

  List<ServiceWithTokens> _getActiveServices(ServicesBundle services) {
    return services.services.where((element) => element.tokens.activeCount != 0).toList(growable: false);
  }

  List<ServiceWithTokens> _getOtherServices(ServicesBundle services) {
    return services.services.where((element) => element.tokens.activeCount == 0).toList(growable: false);
  }

  void _didLoadAllItems(ServicesBundle bundle) {
    _loadedAll = bundle.totalCount <= _itemsCount;
  }
}
