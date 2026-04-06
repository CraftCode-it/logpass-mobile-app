import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/data/wallet/verifier_request.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/home/home_page.dart';
import 'package:logpass_me/presentation/routing/main_router.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

@RoutePage()
class QrScanPage extends HookWidget {
  const QrScanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final hasNavigated = useState(false);
    final controller = useMemoized(MobileScannerController.new);
    useEffect(() => controller.dispose, [controller]);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.secondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(LocaleKeys.qrScan_title.tr(), style: typography.h6.copyWith(color: AppColors.secondary)),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              if (hasNavigated.value) return;
              final barcode = capture.barcodes.firstOrNull;
              if (barcode?.rawValue == null) return;

              final rawValue = barcode!.rawValue!;
              try {
                final request = VerifierRequest.fromQrPayload(rawValue);
                hasNavigated.value = true;
                controller.stop();
                AutoRouter.of(context).push(VerificationRequestRoute(
                  requestId: request.requestId,
                  verifierName: request.verifier,
                  requestType: request.requestType,
                  minAge: request.minAge,
                )).then((result) {
                  if (result == true) {
                    HomePage.reloadActivityNotifier.value++;
                  }
                });
              } catch (e) {
                if (kDebugMode) debugPrint('QR parse error: $e');
                final uuidRegex = RegExp(
                  r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
                );
                if (uuidRegex.hasMatch(rawValue)) {
                  hasNavigated.value = true;
                  controller.stop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(LocaleKeys.qrScan_logpassIdScanned.tr()),
                      duration: const Duration(seconds: 4),
                    ),
                  );
                } else {
                  hasNavigated.value = true;
                  controller.stop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(LocaleKeys.qrScan_unknownQr.tr())),
                  );
                }
              }
            },
          ),
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.success100, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 24,
            right: 24,
            child: Text(
              LocaleKeys.qrScan_hint.tr(),
              style: typography.body1.copyWith(color: AppColors.secondary),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
