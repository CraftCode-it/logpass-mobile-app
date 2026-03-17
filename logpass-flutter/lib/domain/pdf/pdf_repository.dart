import 'dart:io';

abstract class PdfRepository {
  Future<File> loadPdf(String fileName, String url);
}
