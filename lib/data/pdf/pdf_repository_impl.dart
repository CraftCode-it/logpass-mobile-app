import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:logpass_me/data/pdf/pdf_file_downloader.dart';
import 'package:logpass_me/domain/pdf/pdf_repository.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

@Injectable(as: PdfRepository)
class PdfRepositoryImpl implements PdfRepository {
  final PdfFileDownloader _pdfFileDownloader;

  PdfRepositoryImpl(this._pdfFileDownloader);

  @override
  Future<File> loadPdf(String fileName, String url) async {
    final dir = await getTemporaryDirectory();
    final filePath = join(dir.path, fileName);
    final file = File(filePath);

    if (file.existsSync()) return file;

    await _pdfFileDownloader.loadAndSaveFile(file, url);

    return file;
  }
}
