import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/oauth/client.dart';
import 'package:logpass_me/domain/oauth/use_case/assign_to_oauth_attempt_use_case.dart';
import 'package:logpass_me/domain/oauth/use_case/deny_oauth_attempt_use_case.dart';
import 'package:logpass_me/domain/oauth/use_case/get_oauth_application_details_use_case.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'authorize_page_state.dart';
part 'authorize_page_cubit.freezed.dart';

@injectable
class AuthorizePageCubit extends Cubit<AuthorizePageState> {
  final GetOAuthApplicationDetailsUseCase _getOAuthApplicationDetailsUseCase;
  final AssignToOAuthAttemptUseCase _assignToOAuthAttemptUseCase;
  final DenyOAuthAttemptUseCase _denyOAuthAttemptUseCase;

  late String _authorizationAttemptId;
  late bool _shouldRedirect;

  // TODO: should be true after filled required fields (scopes)
  bool get _canConfirm => true;

  AuthorizePageCubit(
    this._getOAuthApplicationDetailsUseCase,
    this._assignToOAuthAttemptUseCase,
    this._denyOAuthAttemptUseCase,
  ) : super(const AuthorizePageState.loading());

  Future<void> init(String authorizationAttemptId) async {
    _authorizationAttemptId = authorizationAttemptId;

    await _startAuthorizationAttempt();
  }

  Future<void> _startAuthorizationAttempt() async {
    try {
      final oAuthApplication = await _getOAuthApplicationDetailsUseCase(_authorizationAttemptId);
      await _assignToOAuthAttemptUseCase(_authorizationAttemptId);
      // TODO: map oAuthApplication.client.requiredScopes for form-widgets like service rules, email etc
      // and determine (based on scopes) which widget should be shown on AuthorizePageState.idle() state;
      // it has been left for debugging purposes

      _shouldRedirect = !oAuthApplication.isRemote;
      _emitIdleState(oAuthApplication.client);
    } on GeneralConnectionError catch (e) {
      emit(AuthorizePageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Failed to start authorization attempt', ex: e, stacktrace: s);
    }
  }

  Future<void> denyAuthorizeAttempt() async {
    emit(const AuthorizePageState.loading());

    final confirmation = await _denyOAuthAttemptUseCase(_authorizationAttemptId);
    final redirectUri = _shouldRedirect ? confirmation.redirectUri : null;

    emit(AuthorizePageState.denied(redirectUri));
  }

  void _emitIdleState(Client client) {
    emit(AuthorizePageState.idle(_canConfirm, client));
  }
}
