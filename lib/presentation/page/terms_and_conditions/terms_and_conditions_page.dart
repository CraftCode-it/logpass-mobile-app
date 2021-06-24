import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/app_bar/navigation_button.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

const _termsAssetPath = 'assets/documents/terms_and_conditions.pdf';

class TermsAndConditionsPage extends HookWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();

    final controller = useMemoized(() => PdfController(document: PdfDocument.openAsset(_termsAssetPath)));
    useEffect(() => controller.dispose, [controller]);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: CustomAppBar.smallTitle(
        leading: NavigationButton.back(),
        title: LocaleKeys.termsAndConditions_title.tr(),
      ),
      body: PdfView(
        controller: controller,
        documentLoader: const Loader(),
        scrollDirection: Axis.vertical,
      ),
    );
  }
}
