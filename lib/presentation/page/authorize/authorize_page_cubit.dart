import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/actions_changed_notifier/use_case/notify_actions_changed_use_case.dart';
import 'package:logpass_me/domain/app_security/use_case/authorize_with_biometrics_use_case.dart';
import 'package:logpass_me/domain/app_security/use_case/is_biometric_available_use_case.dart';
import 'package:logpass_me/domain/data_changed_notifier/data_changed_type.dart';
import 'package:logpass_me/domain/data_changed_notifier/use_case/notify_data_changed_use_case.dart';
import 'package:logpass_me/domain/incoming_actions/incoming_action.dart';
import 'package:logpass_me/domain/model/scope.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/oauth/data/approve_attempt_args.dart';
import 'package:logpass_me/domain/oauth/data/oauth_application.dart';
import 'package:logpass_me/domain/oauth/use_case/approve_oauth_attempt_use_case.dart';
import 'package:logpass_me/domain/oauth/use_case/assign_to_oauth_attempt_use_case.dart';
import 'package:logpass_me/domain/oauth/use_case/deny_oauth_attempt_use_case.dart';
import 'package:logpass_me/domain/oauth/use_case/get_oauth_application_details_use_case.dart';
import 'package:logpass_me/domain/oauth/use_case/init_user_auth_use_case.dart';
import 'package:logpass_me/domain/one_time_code/use_case/load_one_time_code_use_case.dart';
import 'package:logpass_me/domain/service/data/service.dart';
import 'package:logpass_me/domain/service/data/service_agreement.dart';
import 'package:logpass_me/domain/user_data/data/address.dart';
import 'package:logpass_me/domain/user_data/data/invoice_data.dart';
import 'package:logpass_me/domain/user_data/use_case/get_default_invoice_data_use_case.dart';
import 'package:logpass_me/domain/user_data/use_case/get_default_personal_data_use_case.dart';
import 'package:logpass_me/domain/user_data/use_case/get_default_user_address_use_case.dart';
import 'package:logpass_me/domain/user_data/use_case/get_default_user_email_use_case.dart';
import 'package:logpass_me/domain/user_data/use_case/get_user_phone_number_use_case.dart';
import 'package:logpass_me/presentation/page/authorize/scope_element.dart';
import 'package:logpass_me/presentation/page/authorize/scope_renderer.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

part 'authorize_page_cubit.freezed.dart';

part 'authorize_page_state.dart';

@injectable
class AuthorizePageCubit extends Cubit<AuthorizePageState> {
  final GetOAuthApplicationDetailsUseCase _getOAuthApplicationDetailsUseCase;
  final AssignToOAuthAttemptUseCase _assignToOAuthAttemptUseCase;
  final DenyOAuthAttemptUseCase _denyOAuthAttemptUseCase;
  final ApproveOAuthAttemptUseCase _approveOAuthAttemptUseCase;
  final InitUserAuthUseCase _initUserAuthUseCase;

  final LoadOneTimeCodeUseCase _loadOneTimeCodeUseCase;
  final NotifyDataChangedUseCase _notifyDataChangedUseCase;
  final NotifyActionsChangedUseCase _notifyActionsChangedUseCase;
  final ScopeRenderer _scopeRenderer;
  final IsBiometricAvailableUseCase _isBiometricAvailableUseCase;
  final AuthorizeWithBiometricsUseCase _authorizeWithBiometricsUseCase;

  final GetUserPhoneNumberUseCase _getUserPhoneNumberUseCase;
  final GetDefaultInvoiceDataUseCase _getDefaultInvoiceDataUseCase;
  final GetDefaultPersonalDataUseCase _getDefaultPersonalDataUseCase;
  final GetDefaultUserAddressUseCase _getDefaultUserAddressUseCase;
  final GetDefaultUserEmailUseCase _getDefaultUserEmailUseCase;

  bool _shouldRedirect = false;
  List<ScopeElement> _scopeElements = [];
  List<ServiceAgreement> _agreements = [];
  List<Scope> _scopeRequested = [];
  Service? _service;
  bool _biometricCheckNeeded = false;
  int _currentTrustLevel = 1;
  int _requiredTrustLevel = 1;

  late IncomingAction _incomingAction;
  String? _authorizationAttemptId;
  Map<String, String>? _authParameters;

  bool get _canConfirm => _areScopesEligible && _areRequiredAgreementsAccepted && _trustLevelIsReached;

  bool get _areScopesEligible => _scopeElements.every((e) => e.isEligible());

  bool get _areRequiredAgreementsAccepted => _agreements.where((e) => e.isRequired).every((e) => e.isAccepted);

  bool get _trustLevelIsReached => _currentTrustLevel >= _requiredTrustLevel;

  AuthorizePageCubit(
    this._getOAuthApplicationDetailsUseCase,
    this._assignToOAuthAttemptUseCase,
    this._denyOAuthAttemptUseCase,
    this._approveOAuthAttemptUseCase,
    this._loadOneTimeCodeUseCase,
    this._notifyDataChangedUseCase,
    this._notifyActionsChangedUseCase,
    this._scopeRenderer,
    this._isBiometricAvailableUseCase,
    this._authorizeWithBiometricsUseCase,
    this._getDefaultInvoiceDataUseCase,
    this._getDefaultUserAddressUseCase,
    this._getDefaultUserEmailUseCase,
    this._getUserPhoneNumberUseCase,
    this._initUserAuthUseCase,
    this._getDefaultPersonalDataUseCase,
  ) : super(const AuthorizePageState.loading());

  Future<void> init(IncomingAction incomingAction) async {
    _incomingAction = incomingAction;
    _authorizationAttemptId = incomingAction.actionId;
    _authParameters = incomingAction.queryParameters;

    await _startAuthorizationAttempt();
  }

  Future<void> _startAuthorizationAttempt() async {
    try {
      final phoneNumber = await _getUserPhoneNumberUseCase();

      // TODO: adjust handling phone number after 'Add new device' flow will be ready
      final oAuthApplication = await _getOAuthApplicationDetails(phoneNumber!);
      await _assignToOAuthAttemptUseCase(oAuthApplication.id, phoneNumber);

      _service = oAuthApplication.service;
      _agreements = oAuthApplication.service.agreements;
      _scopeRequested = oAuthApplication.scopesRequested;
      _scopeElements = await _getScopeElements(oAuthApplication);
      _shouldRedirect = !oAuthApplication.isRemote;
      _biometricCheckNeeded = oAuthApplication.scopesRequested.contains(Scope.verificationBiometric);
      _requiredTrustLevel = oAuthApplication.trustLevel;

      _emitIdleState();
    } on GeneralConnectionError catch (e) {
      emit(AuthorizePageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Failed to start authorization attempt', ex: e, stacktrace: s);
      _notifyActionsChangedUseCase(_incomingAction);
      emit(const AuthorizePageState.error(true));
    }
  }

  Future<OAuthApplication> _getOAuthApplicationDetails(String phoneNumber) async {
    if (_authorizationAttemptId == null) {
      final oAuthApplication = await _initUserAuthUseCase(_authParameters!);

      _authorizationAttemptId = oAuthApplication.id;

      return oAuthApplication;
    } else {
      return await _getOAuthApplicationDetailsUseCase(_authorizationAttemptId!);
    }
  }

  Future<List<ScopeElement>> _getScopeElements(OAuthApplication application) async {
    final defaultEmail = await _getDefaultUserEmailUseCase();
    final defaultAddress = await _getDefaultUserAddressUseCase();
    final defaultInvoiceData = await _getDefaultInvoiceDataUseCase();
    final defaultPersonalData = await _getDefaultPersonalDataUseCase();

    return _scopeRenderer.renderScopes(
      application.scopesRequested,
      application.service.scopesSupported,
      userEmail: defaultEmail,
      userAddress: defaultAddress,
      invoiceData: defaultInvoiceData,
      personalData: defaultPersonalData,
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

  void updateTrustLevel(int trustLevel) {
    _currentTrustLevel = trustLevel;
    _emitIdleState();
  }

  void updateScopes(ScopeElement element) {
    _scopeElements = _scopeElements.map((e) => (e.scope == element.scope) ? element : e).toList();
    _emitIdleState();
  }

  void updateAgreements(List<ServiceAgreement> agreements) {
    _agreements = agreements;
    _emitIdleState();
  }

  List<Scope> _prepareExtraScopeList() {
    final acceptedOptionalAgreements =
        _agreements.where((e) => !e.isRequired && e.isAccepted).map((e) => e.scope).whereType<Scope>().toList();

    return [..._scopeRequested, ...acceptedOptionalAgreements];
  }

  Future<ApproveAttemptArgs> _prepareApproveAttemptArgs() async {
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
    final personalData = '';
    final phoneNumber = await _getUserPhoneNumberUseCase();

    print('ANDRII localeName: ${Platform.localeName}');
    print('ANDRII localHostname: ${Platform.localHostname}');
    print('ANDRII phoneNumber: ${phoneNumber}');

    return ApproveAttemptArgs(
      email: _email ?? 'john.smith@example.com',
      emailVerified: false,
      name: null,
      extraScopes: _prepareExtraScopeList(),
      address: _address,
      invoice: _invoiceData,
      phoneNumberVerified: true,
      phoneNumber: phoneNumber,
      locale: 'en-GB',
      surname: null,
    );
  }

  Future<void> approveAuthorizeAttemptWithBiometric() async {
    final confirmed = await _authorizeWithBiometricsUseCase();
    if (confirmed) await approveAuthorizeAttempt(biometricConfirmed: true);
  }

  Future<void> approveAuthorizeAttempt({bool biometricConfirmed = false}) async {
    try {
      if (_authorizationAttemptId == null) {
        emit(AuthorizePageState.error(false, retryCallback: () => approveAuthorizeAttempt(biometricConfirmed: true)));
        return;
      }

      final verified = await _preAuthorizeWithBiometric(biometricConfirmed);
      if (!verified) return;

      emit(const AuthorizePageState.loading());

      final args = await _prepareApproveAttemptArgs();
      final confirmation = await _approveOAuthAttemptUseCase(_authorizationAttemptId!, args);
      final redirectUri = _shouldRedirect ? confirmation.redirectUri : null;

      await _notifyDataChangedUseCase(DataChangedType.service);
      _notifyActionsChangedUseCase(_incomingAction);
      await _loadOneTimeCodeUseCase();

      emit(AuthorizePageState.confirmed(redirectUri));
    } on GeneralConnectionError catch (e) {
      emit(AuthorizePageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Failed to approve authorization attempt', ex: e, stacktrace: s);

      emit(AuthorizePageState.error(false, retryCallback: () => approveAuthorizeAttempt(biometricConfirmed: true)));
    }
  }

  Future<void> denyAuthorizeAttempt() async {
    try {
      if (_authorizationAttemptId == null) {
        emit(AuthorizePageState.error(false, retryCallback: () => approveAuthorizeAttempt(biometricConfirmed: true)));
        return;
      }

      emit(const AuthorizePageState.loading());

      final confirmation = await _denyOAuthAttemptUseCase(_authorizationAttemptId!);
      final redirectUri = _shouldRedirect ? confirmation.redirectUri : null;

      _notifyActionsChangedUseCase(_incomingAction);
      await _loadOneTimeCodeUseCase();

      emit(AuthorizePageState.denied(redirectUri));
    } on GeneralConnectionError catch (e) {
      emit(AuthorizePageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Failed to deny authorization attempt', ex: e, stacktrace: s);

      emit(AuthorizePageState.error(false, retryCallback: denyAuthorizeAttempt));
    }
  }

  void _emitIdleState() {
    emit(AuthorizePageState.idle(
      _canConfirm,
      _service!,
      _scopeElements,
      _agreements,
      _requiredTrustLevel,
      _currentTrustLevel,
    ));
  }
}
