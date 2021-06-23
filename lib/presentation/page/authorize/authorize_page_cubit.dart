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
import 'package:logpass_me/domain/oauth/use_case/approve_oauth_attempt_use_case.dart';
import 'package:logpass_me/domain/oauth/use_case/assign_to_oauth_attempt_use_case.dart';
import 'package:logpass_me/domain/oauth/use_case/deny_oauth_attempt_use_case.dart';
import 'package:logpass_me/domain/oauth/use_case/get_oauth_application_details_use_case.dart';
import 'package:logpass_me/domain/one_time_code/use_case/load_one_time_code.dart';
import 'package:logpass_me/domain/service/data/service.dart';
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

  bool _shouldRedirect = false;
  List<ScopeElement> _scopeElements = [];
  List<ServiceAgreement> _agreements = [];
  Service? _service;
  bool _biometricCheckNeeded = false;

  late String _authorizationAttemptId;

  // TODO: add check for required agreements when page will be ready
  bool get _canConfirm => _scopeElements.every((e) => e.isEligible);

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
      _scopeElements = _scopeRenderer.renderScopes(
        oAuthApplication.scopesRequested,
        oAuthApplication.service.scopesSupported,
      );
      _shouldRedirect = !oAuthApplication.isRemote;
      _biometricCheckNeeded = oAuthApplication.scopesRequested.contains(Scope.verificationBiometric);

      _emitIdleState();
    } on GeneralConnectionError catch (e) {
      emit(AuthorizePageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Failed to start authorization attempt', ex: e, stacktrace: s);
    }
  }

  Future<bool> _preAuthorizeWithBiometric() async {
    // TODO: handle case where biometric is needed, is available but is not set
    if (_biometricCheckNeeded) {
      final isBiometricAvailable = await _isBiometricAvailableUseCase();
      if (isBiometricAvailable) {
        return await _authorizeWithBiometricsUseCase();
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  Future<void> approveAuthorizeAttempt() async {
    // TODO: fix after implmentation of pages for required scopes
    final args = ApproveAttemptArgs(
      email: 'john.smith@example.com',
      emailVerified: false,
      name: 'John Smith',
    );
    try {
      final verified = await _preAuthorizeWithBiometric();
      if (!verified) {
        emit(const AuthorizePageState.biometricVerificationFailed());
        return;
      }

      emit(const AuthorizePageState.loading());

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
