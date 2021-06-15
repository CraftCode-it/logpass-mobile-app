import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:logpass_me/domain/pdf/pdf_repository.dart';
import 'package:logpass_me/domain/service/data/service_agreement.dart';

@Injectable()
class GetAgreementPdfFileUseCase {
  final PdfRepository _pdfRepository;

  GetAgreementPdfFileUseCase(this._pdfRepository);

  Future<File> call(ServiceAgreement agreement) async {
    final fileName = '${agreement.id}.pdf';
    return _pdfRepository.loadPdf(fileName, agreement.url);
  }
}
