import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/oauth/use_case/get_oauth_application_details_use_case.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';

part 'authorize_page_state.dart';
part 'authorize_page_cubit.freezed.dart';

@injectable
class AuthorizePageCubit extends Cubit<AuthorizePageState> {
  final GetOAuthApplicationDetailsUseCase _getOAuthApplicationDetailsUseCase;

  late String _authorizationAttemptId;

  AuthorizePageCubit(this._getOAuthApplicationDetailsUseCase) : super(const AuthorizePageState.loading());

  Future<void> init(String authorizationAttemptId) async {
    _authorizationAttemptId = authorizationAttemptId;

    await _getApplicationDetails();
  }

  Future<void> _getApplicationDetails() async {
    try {
      final result = await _getOAuthApplicationDetailsUseCase(_authorizationAttemptId);
    } on GeneralConnectionError catch (e) {
      emit(AuthorizePageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Failed to load application details', ex: e, stacktrace: s);
    }
  }
}
