import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:logpass_me/data/wallet/verifier_request.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/guardian/guardian_cubit.dart';
import 'package:logpass_me/presentation/page/home/home_page.dart';
import 'package:logpass_me/presentation/routing/main_router.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

@RoutePage()
class QrScanPage extends HookWidget {
  const QrScanPage({Key? key}) : super(key: key);

  static const _uuidRegex = r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$';

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final hasNavigated = useState(false);
    final controller = useMemoized(MobileScannerController.new);
    useEffect(() => controller.dispose, [controller]);

    return BlocProvider(
      create: (_) => GetIt.I<GuardianCubit>(),
      child: Builder(
        builder: (context) => Scaffold(
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
                    final uuidMatch = RegExp(_uuidRegex).hasMatch(rawValue);
                    if (uuidMatch) {
                      hasNavigated.value = true;
                      controller.stop();
                      _showGuardianRelationshipDialog(context, rawValue);
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
        ),
      ),
    );
  }

  void _showGuardianRelationshipDialog(BuildContext context, String minorUserId) {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _RelationshipDialog(
        minorUserId: minorUserId,
        onConfirm: (relationship) {
          Navigator.of(dialogContext).pop();
          final cubit = BlocProvider.of<GuardianCubit>(context);
          cubit.addMinor(minorUserId, relationshipType: relationship).then((_) {
            final state = cubit.state;
            if (state is GuardianError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(LocaleKeys.guardian_requestSent.tr())),
              );
            }
            Navigator.of(context).pop();
          });
        },
        onCancel: () {
          Navigator.of(dialogContext).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class _RelationshipDialog extends StatefulWidget {
  final String minorUserId;
  final void Function(String relationship) onConfirm;
  final VoidCallback onCancel;

  const _RelationshipDialog({
    required this.minorUserId,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<_RelationshipDialog> createState() => _RelationshipDialogState();
}

class _RelationshipDialogState extends State<_RelationshipDialog> {
  String _selected = 'parent';

  static const _relationships = [
    ('parent', 'Rodzic'),
    ('legal_guardian', 'Opiekun prawny'),
    ('relative', 'Krewny'),
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(LocaleKeys.guardian_selectRelationship.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: _relationships.map((r) {
          return RadioListTile<String>(
            value: r.$1,
            groupValue: _selected,
            title: Text(r.$2),
            onChanged: (v) => setState(() => _selected = v!),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: Text(LocaleKeys.common_cancel.tr()),
        ),
        ElevatedButton(
          onPressed: () => widget.onConfirm(_selected),
          child: Text(LocaleKeys.guardian_confirmRequest.tr()),
        ),
      ],
    );
  }
}
