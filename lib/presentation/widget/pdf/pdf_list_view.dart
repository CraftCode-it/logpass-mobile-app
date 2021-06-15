import 'package:flutter/material.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:synchronized/synchronized.dart';

final Lock _lock = Lock();

class PdfListView extends StatelessWidget {
  final PdfDocument document;

  const PdfListView({required this.document, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => AspectRatio(
        aspectRatio: AppDimens.aspectRatioA4,
        child: _PdfPage(
          pageLoader: () => document.getPage(index + 1),
          key: ValueKey(index),
        ),
      ),
      itemCount: document.pagesCount,
    );
  }
}

class _PdfPage extends StatelessWidget {
  final Future<PdfPage> Function() pageLoader;

  const _PdfPage({required this.pageLoader, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FutureBuilder<PdfPageImage>(
      future: _getImage(pageLoader, size),
      builder: (context, snapshot) {
        final data = snapshot.data;

        if (data == null) {
          return const Loader();
        } else {
          return _PageImage(
            image: data,
            key: ValueKey(data.id),
          );
        }
      },
    );
  }

  Future<PdfPageImage> _getImage(Future<PdfPage> Function() pdfPageLoader, Size size) async {
    return _lock.synchronized(
      () async {
        final page = await pdfPageLoader();

        try {
          final image = await page.render(
            width: page.width,
            height: page.height,
            format: PdfPageFormat.JPEG,
          );

          if (image == null) throw Exception('Loading pdf page failed');

          return image;
        } finally {
          await page.close();
        }
      },
    );
  }
}

class _PageImage extends StatelessWidget {
  final PdfPageImage image;

  const _PageImage({required this.image, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      image.bytes,
      key: ValueKey(image),
    );
  }
}
