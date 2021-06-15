import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class PdfFileDownloader {
  Future<void> loadAndSaveFile(File file, String url) async {
    final args = _PdfFileArgs(file, url);
    await compute(_loadAndSave, args);
  }

  static Future<void> _loadAndSave(_PdfFileArgs args) async {
    final client = HttpClient();

    try {
      final uri = Uri.parse(args.url);
      final request = await client.getUrl(uri);
      final response = await request.close();

      if (response.statusCode != HttpStatus.ok) throw Exception('Loading pdf failed with code ${response.statusCode}');

      await response.pipe(args.file.openWrite());
    } finally {
      client.close(force: true);
    }
  }
}

class _PdfFileArgs {
  final File file;
  final String url;

  _PdfFileArgs(this.file, this.url);
}
