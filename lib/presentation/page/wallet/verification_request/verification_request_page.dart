import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

@RoutePage()
class VerificationRequestPage extends HookWidget {
  final String? verifierName;
  final String? requestType;
  final int? minAge;

  const VerificationRequestPage({
    Key? key,
    this.verifierName,
    this.requestType,
    this.minAge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();
    final isProcessing = useState(false);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: colors.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Verification Request', style: typography.h6.copyWith(color: colors.text)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors.secondaryBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.dividerMedium),
              ),
              child: Column(
                children: [
                  Icon(Icons.shield, size: 48, color: colors.text),
                  const SizedBox(height: 16),
                  Text(
                    verifierName ?? 'Unknown Verifier',
                    style: typography.h4,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'is requesting verification',
                    style: typography.body1.copyWith(color: colors.secondaryText),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _RequestDetail(
              icon: Icons.verified_user,
              title: 'Verification Type',
              value: requestType ?? 'Age Verification',
              colors: colors,
              typography: typography,
            ),
            const SizedBox(height: 16),
            _RequestDetail(
              icon: Icons.cake,
              title: 'Minimum Age',
              value: '${minAge ?? 18}+',
              colors: colors,
              typography: typography,
            ),
            const SizedBox(height: 16),
            _RequestDetail(
              icon: Icons.privacy_tip,
              title: 'Data Shared',
              value: 'Zero-Knowledge Proof only\nNo personal data revealed',
              colors: colors,
              typography: typography,
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton(
                      onPressed: isProcessing.value ? null : () => Navigator.of(context).pop(),
                      child: Text('Decline', style: typography.h8.copyWith(color: colors.buttonOutlinedText)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: colors.buttonOutlined),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isProcessing.value
                          ? null
                          : () {
                              isProcessing.value = true;
                              // Generate and share proof
                            },
                      child: isProcessing.value
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2, color: colors.buttonFilledText),
                            )
                          : Text('Approve', style: typography.h8.copyWith(color: colors.buttonFilledText)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success100,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _RequestDetail extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final AppThemeColors colors;
  final AppTypography typography;

  const _RequestDetail({
    required this.icon,
    required this.title,
    required this.value,
    required this.colors,
    required this.typography,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: colors.secondaryText),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: typography.info2.copyWith(color: colors.secondaryText)),
                const SizedBox(height: 2),
                Text(value, style: typography.body2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
