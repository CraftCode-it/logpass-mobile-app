import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/agreement/use_case/confirm_agreement_use_case.dart';
import 'package:logpass_me/domain/agreement/use_case/revoke_agreement_use_case.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/pdf/use_case/get_agreement_pdf_file_use_case.dart';
import 'package:logpass_me/domain/service/data/service_agreement.dart';
import 'package:logpass_me/presentation/page/agreement_details/agreement_details_page_state.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';

@Injectable()
class AgreementDetailsPageCubit extends Cubit<AgreementDetailsPageState> {
  final GetAgreementPdfFileUseCase _getAgreementPdfFileUseCase;
  final ConfirmAgreementUseCase _confirmAgreementUseCase;
  final RevokeAgreementUseCase _revokeAgreementUseCase;

  late ServiceAgreement _agreement;
  PdfDocument? _document;

  AgreementDetailsPageCubit(
    this._getAgreementPdfFileUseCase,
    this._confirmAgreementUseCase,
    this._revokeAgreementUseCase,
  ) : super(AgreementDetailsPageState.initializing());

  @override
  Future<void> close() async {
    await _document?.close();
    return super.close();
  }

  Future<void> initialize(ServiceAgreement agreement) async {
    _agreement = agreement;

    emit(AgreementDetailsPageState.loadingPdf(_agreement));

    try {
      final file = await _getAgreementPdfFileUseCase(_agreement);
      _document = await PdfDocument.openFile(file.path);
    } on GeneralConnectionError catch (e) {
      emit(AgreementDetailsPageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Loading PDF failed', ex: e, stacktrace: s);
      emit(AgreementDetailsPageState.connectionError(GeneralConnectionError.somethingWentWrong()));
    }

    emit(AgreementDetailsPageState.idle(_document, _agreement));
  }

  Future<void> revokeAgreement() async {
    emit(AgreementDetailsPageState.processing(_document, _agreement));

    try {
      await _revokeAgreementUseCase(_agreement);
      _agreement = _agreement.copyWith(isAccepted: false);
      emit(AgreementDetailsPageState.revoked());
    } on GeneralConnectionError catch (e) {
      emit(AgreementDetailsPageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Revoking agreement failed', ex: e, stacktrace: s);
      emit(AgreementDetailsPageState.connectionError(GeneralConnectionError.somethingWentWrong()));
    } finally {
      emit(AgreementDetailsPageState.idle(_document, _agreement));
    }
  }

  Future<void> confirmAgreement() async {
    emit(AgreementDetailsPageState.processing(_document, _agreement));

    try {
      await _confirmAgreementUseCase(_agreement);
      _agreement = _agreement.copyWith(isAccepted: true);
      emit(AgreementDetailsPageState.confirmed());
    } on GeneralConnectionError catch (e) {
      emit(AgreementDetailsPageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Confirming agreement failed', ex: e, stacktrace: s);
      emit(AgreementDetailsPageState.connectionError(GeneralConnectionError.somethingWentWrong()));
    } finally {
      emit(AgreementDetailsPageState.idle(_document, _agreement));
    }
  }
}
