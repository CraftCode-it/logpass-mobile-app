import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:pdfx/pdfx.dart';
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
          pageLoader: document.getPage(index + 1),
          key: ValueKey(index),
        ),
      ),
      itemCount: document.pagesCount,
    );
  }
}

class _PdfPage extends HookWidget {
  final Future<PdfPage> pageLoader;

  const _PdfPage({required this.pageLoader, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final page = useFuture(pageLoader, preserveState: false);
    final size = MediaQuery.of(context).size;

    final data = page.data;

    if (data == null) {
      return const Loader();
    } else {
      return FutureBuilder<PdfPageImage?>(
        future: _getImage(data, size),
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
  }

  Future<PdfPageImage?> _getImage(PdfPage page, Size size) async {
    return _lock.synchronized(
      () async {
        final image = await page.render(
          width: page.width,
          height: page.height,
              format: PdfPageImageFormat.jpeg,
        );
        await page.close();

        return image;
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
