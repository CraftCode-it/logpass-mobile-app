import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/networking/error/general_connection_error.dart';
import 'package:logpass_me/domain/pdf/use_case/get_agreement_pdf_file_use_case.dart';
import 'package:logpass_me/domain/service/data/service_agreement.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';

part 'agreement_content_preview_page_state.dart';
part 'agreement_content_preview_page_cubit.freezed.dart';

@injectable
class AgreementContentPreviewPageCubit extends Cubit<AgreementContentPreviewPageState> {
  final GetAgreementPdfFileUseCase _getAgreementPdfFileUseCase;

  late ServiceAgreement _agreement;
  PdfDocument? _document;

  AgreementContentPreviewPageCubit(
    this._getAgreementPdfFileUseCase,
  ) : super(const AgreementContentPreviewPageState.loading());

  @override
  Future<void> close() async {
    await _document?.close();
    return super.close();
  }

  Future<void> init(ServiceAgreement agreement) async {
    _agreement = agreement;

    try {
      final file = await _getAgreementPdfFileUseCase(_agreement);
      final document = await PdfDocument.openFile(file.path);
      _document = document;

      emit(AgreementContentPreviewPageState.idle(document));
    } on GeneralConnectionError catch (e) {
      emit(AgreementContentPreviewPageState.connectionError(e));
    } catch (e, s) {
      Fimber.e('Loading PDF failed', ex: e, stacktrace: s);
      emit(AgreementContentPreviewPageState.connectionError(GeneralConnectionError.somethingWentWrong()));
    }
  }
}
