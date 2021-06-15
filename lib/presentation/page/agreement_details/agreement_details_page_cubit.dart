
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/pdf/use_case/get_agreement_pdf_file_use_case.dart';
import 'package:logpass_me/domain/service/data/service_agreement.dart';
import 'package:logpass_me/presentation/page/agreement_details/agreement_details_page_state.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';

@Injectable()
class AgreementDetailsPageCubit extends Cubit<AgreementDetailsPageState> {
  final GetAgreementPdfFileUseCase _getAgreementPdfFileUseCase;

  late ServiceAgreement _agreement;
  PdfDocument? _document;

  AgreementDetailsPageCubit(this._getAgreementPdfFileUseCase) : super(AgreementDetailsPageState.initializing());

  @override
  Future<void> close() async {
    await _document?.close();
    return super.close();
  }

  Future<void> initialize(ServiceAgreement agreement) async {
    _agreement = agreement;

    emit(AgreementDetailsPageState.loadingPdf(_agreement));

    final file = await _getAgreementPdfFileUseCase(_agreement);
    final _document = await PdfDocument.openFile(file.path);

    emit(AgreementDetailsPageState.idle(_document, _agreement));
  }

  Future<void> revokeAgreement() async {
    emit(AgreementDetailsPageState.processing(_document, _agreement));
  }

  Future<void> confirmAgreement() async {
    emit(AgreementDetailsPageState.processing(_document, _agreement));
  }
}
