import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/core/di/di_config.dart';
import 'package:logpass_me/domain/wallet/credential.dart';
import 'package:logpass_me/domain/wallet/wallet_repository.dart';
import 'package:logpass_me/presentation/routing/main_router.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

@RoutePage()
class CredentialDetailPage extends HookWidget {
  final Credential credential;

  const CredentialDetailPage({Key? key, required this.credential}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Credential Details', style: typography.h6.copyWith(color: colors.text)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _StatusBanner(credential: credential, colors: colors, typography: typography),
            const SizedBox(height: 32),
            _DetailSection(
              title: 'Type',
              value: credential.displayType,
              colors: colors,
              typography: typography,
            ),
            _DetailSection(
              title: 'Status',
              value: credential.status.toUpperCase(),
              colors: colors,
              typography: typography,
              valueColor: credential.isValid ? AppColors.success100 : AppColors.error100,
            ),
            _DetailSection(
              title: 'Result',
              value: credential.result == true ? 'PASS' : 'FAIL',
              colors: colors,
              typography: typography,
              valueColor: credential.result == true ? AppColors.success100 : AppColors.error100,
            ),
            if (credential.validUntil != null)
              _DetailSection(
                title: 'Valid Until',
                value: _formatDate(credential.validUntil!),
                colors: colors,
                typography: typography,
              ),
            _DetailSection(
              title: 'Issued At',
              value: _formatDate(credential.issuedAt),
              colors: colors,
              typography: typography,
            ),
            if (credential.commitmentHash != null) ...[
              const SizedBox(height: 16),
              _HashSection(
                title: 'Commitment Hash',
                hash: credential.commitmentHash!,
                colors: colors,
                typography: typography,
              ),
            ],
            if (credential.isAnchored) ...[
              const SizedBox(height: 16),
              _HashSection(
                title: 'On-Chain TX ID',
                hash: credential.onChainTxId!,
                colors: colors,
                typography: typography,
                icon: Icons.link,
              ),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: credential.isValid
                    ? () async {
                        final repo = getIt<WalletRepository>();
                        try {
                          final proof = await repo.generateProof(credential.id);
                          if (context.mounted) {
                            AutoRouter.of(context).push(
                              ProofPresentationRoute(credential: credential, proofData: proof),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            AutoRouter.of(context).push(
                              ProofPresentationRoute(credential: credential),
                            );
                          }
                        }
                      }
                    : null,
                icon: Icon(Icons.qr_code, color: credential.isValid ? colors.buttonOutlinedText : colors.lightText),
                label: Text(
                  'Generate ZK Proof',
                  style: typography.h8.copyWith(
                    color: credential.isValid ? colors.buttonOutlinedText : colors.lightText,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: credential.isValid ? colors.buttonOutlined : colors.buttonOutlinedInactive,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _StatusBanner extends StatelessWidget {
  final Credential credential;
  final AppThemeColors colors;
  final AppTypography typography;

  const _StatusBanner({
    required this.credential,
    required this.colors,
    required this.typography,
  });

  @override
  Widget build(BuildContext context) {
    final isValid = credential.isValid;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isValid
              ? [AppColors.success100, AppColors.success80]
              : [AppColors.error100, AppColors.error80],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            isValid ? Icons.verified : Icons.gpp_bad,
            size: 48,
            color: AppColors.secondary,
          ),
          const SizedBox(height: 12),
          Text(
            credential.displayType,
            style: typography.h3.copyWith(color: AppColors.secondary),
          ),
          const SizedBox(height: 4),
          Text(
            isValid ? 'Verified & Valid' : 'Invalid / Expired',
            style: typography.body1.copyWith(color: AppColors.secondary.withOpacity(0.9)),
          ),
          if (credential.isAnchored) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.link, size: 14, color: AppColors.secondary),
                  const SizedBox(width: 4),
                  Text(
                    'On-Chain Anchored',
                    style: typography.info2.copyWith(color: AppColors.secondary),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final String value;
  final AppThemeColors colors;
  final AppTypography typography;
  final Color? valueColor;

  const _DetailSection({
    required this.title,
    required this.value,
    required this.colors,
    required this.typography,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: typography.body1.copyWith(color: colors.secondaryText)),
          Text(
            value,
            style: typography.body3.copyWith(color: valueColor ?? colors.text),
          ),
        ],
      ),
    );
  }
}

class _HashSection extends StatelessWidget {
  final String title;
  final String hash;
  final AppThemeColors colors;
  final AppTypography typography;
  final IconData icon;

  const _HashSection({
    required this.title,
    required this.hash,
    required this.colors,
    required this.typography,
    this.icon = Icons.fingerprint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: colors.secondaryText),
            const SizedBox(width: 6),
            Text(title, style: typography.info1.copyWith(color: colors.secondaryText)),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: hash));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Copied to clipboard'), duration: Duration(seconds: 1)),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.secondaryBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.dividerMedium),
            ),
            child: Text(
              hash,
              style: typography.info2.copyWith(
                fontFamily: 'monospace',
                color: colors.text,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
