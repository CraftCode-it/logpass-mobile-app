import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/app_security/use_case/authorize_with_biometrics_use_case.dart';
import 'package:logpass_me/domain/app_security/use_case/is_biometric_available_use_case.dart';
import 'package:logpass_me/domain/data_changed_notifier/data_changed_type.dart';
import 'package:logpass_me/domain/data_changed_notifier/use_case/notify_data_changed_use_case.dart';
import 'package:logpass_me/domain/model/scope.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/oauth/data/approve_attempt_args.dart';
import 'package:logpass_me/domain/oauth/data/oauth_application.dart';
import 'package:logpass_me/domain/oauth/use_case/approve_oauth_attempt_use_case.dart';
import 'package:logpass_me/domain/oauth/use_case/assign_to_oauth_attempt_use_case.dart';
import 'package:logpass_me/domain/oauth/use_case/deny_oauth_attempt_use_case.dart';
import 'package:logpass_me/domain/oauth/use_case/get_oauth_application_details_use_case.dart';
import 'package:logpass_me/domain/one_time_code/use_case/load_one_time_code.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';
import 'package:logpass_me/domain/user_data/use_case/get_default_invoice_data_use_case.dart';
import 'package:logpass_me/domain/user_data/use_case/get_default_user_address_use_case.dart';
import 'package:logpass_me/domain/user_data/use_case/get_default_user_email_use_case.dart';
import 'package:logpass_me/presentation/page/authorize/scope_element.dart';
import 'package:logpass_me/presentation/page/authorize/scope_renderer.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/domain/service/data/service_agreement.dart';

part 'authorize_page_cubit.freezed.dart';
part 'authorize_page_state.dart';

@injectable
class AuthorizePageCubit extends Cubit<AuthorizePageState> {
  final GetOAuthApplicationDetailsUseCase _getOAuthApplicationDetailsUseCase;
  final AssignToOAuthAttemptUseCase _assignToOAuthAttemptUseCase;
  final DenyOAuthAttemptUseCase _denyOAuthAttemptUseCase;
  final ApproveOAuthAttemptUseCase _approveOAuthAttemptUseCase;

  final LoadOneTimeCodeUseCase _loadOneTimeCodeUseCase;
  final NotifyDataChangedUseCase _notifyDataChangedUseCase;
  final ScopeRenderer _scopeRenderer;
  final IsBiometricAvailableUseCase _isBiometricAvailableUseCase;
  final AuthorizeWithBiometricsUseCase _authorizeWithBiometricsUseCase;

  final GetDefaultInvoiceDataUseCase _getDefaultInvoiceDataUseCase;
  final GetDefaultUserAddressUseCase _getDefaultUserAddressUseCase;
  final GetDefaultUserEmailUseCase _getDefaultUserEmailUseCase;

  bool _shouldRedirect = false;
  List<ScopeElement> _scopeElements = [];
  List<ServiceAgreement> _agreements = [];
  List<Scope> _scopeRequested = [];
  Service? _service;
  bool _biometricCheckNeeded = false;

  late String _authorizationAttemptId;

  bool get _canConfirm => _areScopesEligible && _areRequiredAgreementsAccepted;
  bool get _areScopesEligible => _scopeElements.every((e) => e.isEligible());
  bool get _areRequiredAgreementsAccepted => _agreements.where((e) => e.isRequired).every((e) => e.isAccepted);

  AuthorizePageCubit(
    this._getOAuthApplicationDetailsUseCase,
    this._assignToOAuthAttemptUseCase,
    this._denyOAuthAttemptUseCase,
    this._approveOAuthAttemptUseCase,
    this._loadOneTimeCodeUseCase,
    this._notifyDataChangedUseCase,
    this._scopeRenderer,
    this._isBiometricAvailableUseCase,
    this._authorizeWithBiometricsUseCase,
    this._getDefaultInvoiceDataUseCase,
    this._getDefaultUserAddressUseCase,
    this._getDefaultUserEmailUseCase,
  ) : super(const AuthorizePageState.loading());

  Future<void> init(String authorizationAttemptId) async {
    _authorizationAttemptId = authorizationAttemptId;

    await _startAuthorizationAttempt();
  }

  Future<void> _startAuthorizationAttempt() async {
    try {
      final oAuthApplication = await _getOAuthApplicationDetailsUseCase(_authorizationAttemptId);
      await _assignToOAuthAttemptUseCase(_authorizationAttemptId);

      _service = oAuthApplication.service;
      _agreements = oAuthApplication.service.agreements;
      _scopeRequested = oAuthApplication.scopesRequested;
      _scopeElements = await _getScopeElements(oAuthApplication);
      _shouldRedirect = !oAuthApplication.isRemote;
      _biometricCheckNeeded = oAuthApplication.scopesRequested.contains(Scope.verificationBiometric);

      _emitIdleState();
    } on GeneralConnectionError catch (e) {
      emit(AuthorizePageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Failed to start authorization attempt', ex: e, stacktrace: s);
    }
  }

  Future<List<ScopeElement>> _getScopeElements(OAuthApplication application) async {
    final defaultEmail = await _getDefaultUserEmailUseCase();
    final defaultAddress = await _getDefaultUserAddressUseCase();
    final defaultInvoiceData = await _getDefaultInvoiceDataUseCase();

    return _scopeRenderer.renderScopes(
      application.scopesRequested,
      application.service.scopesSupported,
      userEmail: defaultEmail,
      userAddress: defaultAddress,
      invoiceData: defaultInvoiceData,
    );
  }

  Future<bool> _preAuthorizeWithBiometric(bool biometricConfirmed) async {
    if (_biometricCheckNeeded && !biometricConfirmed) {
      final isBiometricAvailable = await _isBiometricAvailableUseCase();
      if (isBiometricAvailable) {
        emit(const AuthorizePageState.biometricVerificationNeeded());
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  void updateScopes(ScopeElement element) {
    _scopeElements = _scopeElements.map((e) => (e.scope == element.scope) ? element : e).toList();
    _emitIdleState();
  }

  void updateAgreements(List<ServiceAgreement> agreements) {
    _agreements = agreements;
    _emitIdleState();
  }

  ApproveAttemptArgs _prepareApproveAttemptArgs() {
    String? _email;
    Address? _address;
    InvoiceData? _invoiceData;

    for (final element in _scopeElements) {
      element.maybeMap(
        email: (state) => _email = state.email?.value,
        address: (state) => _address = state.address,
        invoice: (state) => _invoiceData = state.invoiceData,
        orElse: () {},
      );
    }
    // TODO: handle after backend's implementation
    final personalData = 'John Smith';

    return ApproveAttemptArgs(
      email: _email ?? 'john.smith@example.com',
      emailVerified: false,
      name: personalData,
      // TODO: update extra scopes with optional agreements
      extraScopes: _scopeRequested,
      address: _address,
      invoice: _invoiceData,
    );
  }

  Future<void> approveAuthorizeAttemptWithBiometric() async {
    final confirmed = await _authorizeWithBiometricsUseCase();
    if (confirmed) await approveAuthorizeAttempt(biometricConfirmed: true);
  }

  Future<void> approveAuthorizeAttempt({bool biometricConfirmed = false}) async {
    try {
      final verified = await _preAuthorizeWithBiometric(biometricConfirmed);
      if (!verified) return;

      emit(const AuthorizePageState.loading());

      final args = _prepareApproveAttemptArgs();
      final confirmation = await _approveOAuthAttemptUseCase(_authorizationAttemptId, args);
      final redirectUri = _shouldRedirect ? confirmation.redirectUri : null;

      await _notifyDataChangedUseCase(DataChangedType.service);
      emit(AuthorizePageState.confirmed(redirectUri));
    } on GeneralConnectionError catch (e) {
      emit(AuthorizePageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Failed to start authorization attempt', ex: e, stacktrace: s);
    } finally {
      await _loadOneTimeCodeUseCase();
    }
  }

  Future<void> denyAuthorizeAttempt() async {
    emit(const AuthorizePageState.loading());

    try {
      final confirmation = await _denyOAuthAttemptUseCase(_authorizationAttemptId);
      final redirectUri = _shouldRedirect ? confirmation.redirectUri : null;

      emit(AuthorizePageState.denied(redirectUri));
    } on GeneralConnectionError catch (e) {
      emit(AuthorizePageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Failed to start authorization attempt', ex: e, stacktrace: s);
    } finally {
      await _loadOneTimeCodeUseCase();
    }
  }

  void _emitIdleState() {
    emit(AuthorizePageState.idle(_canConfirm, _service!, _scopeElements, _agreements));
  }
}
