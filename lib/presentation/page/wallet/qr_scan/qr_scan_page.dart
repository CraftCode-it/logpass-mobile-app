import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

@RoutePage()
class QrScanPage extends HookWidget {
  const QrScanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Scan QR Code', style: typography.h6.copyWith(color: Colors.white)),
      ),
      body: Stack(
        children: [
          // Camera preview placeholder
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.success100, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_scanner, size: 64, color: Colors.white.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'Camera Preview',
                    style: typography.body1.copyWith(color: Colors.white.withOpacity(0.5)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'QR scanner requires\nFlutter 3.x + camera package',
                    style: typography.info2.copyWith(color: Colors.white.withOpacity(0.3)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          // Bottom instructions
          Positioned(
            bottom: 80,
            left: 24,
            right: 24,
            child: Column(
              children: [
                Text(
                  'Point your camera at a verifier\'s QR code',
                  style: typography.body1.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Manual entry fallback for MVP
                      _showManualEntry(context, colors, typography);
                    },
                    icon: const Icon(Icons.keyboard, color: Colors.white),
                    label: Text(
                      'Enter Code Manually',
                      style: typography.body2.copyWith(color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showManualEntry(BuildContext context, AppThemeColors colors, AppTypography typography) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.dialogBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter Verification Code', style: typography.h6),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Paste code here...',
                  hintStyle: TextStyle(color: colors.inputHint),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colors.inputFocusedBorder),
                  ),
                ),
                style: typography.body1,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(controller.text);
                  },
                  child: Text('Submit', style: typography.h8.copyWith(color: colors.buttonFilledText)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.buttonFill,
                    foregroundColor: colors.buttonFilledText,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
