import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/core/di/di_config.dart';
import 'package:logpass_me/domain/wallet/credential.dart';
import 'package:logpass_me/domain/wallet/wallet_repository.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:qr_flutter/qr_flutter.dart';

@RoutePage()
class ProofPresentationPage extends HookWidget {
  final Credential credential;
  final Map<String, dynamic>? proofData;

  const ProofPresentationPage({
    Key? key,
    required this.credential,
    this.proofData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();
    final isGenerating = useState(proofData == null);
    final proof = useState<Map<String, dynamic>?>(proofData);

    useEffect(() {
      if (proofData == null) {
        final repo = getIt<WalletRepository>();
        repo.generateProof(credential.id).then((data) {
          proof.value = data;
          isGenerating.value = false;
        }).catchError((_) {
          isGenerating.value = false;
        });
      }
      return;
    }, [credential.id]);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('ZK Proof', style: typography.h6.copyWith(color: colors.text)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: isGenerating.value
            ? _GeneratingState(colors: colors, typography: typography)
            : proof.value != null
                ? _ProofReadyState(
                    proof: proof.value!,
                    credential: credential,
                    colors: colors,
                    typography: typography,
                  )
                : _ErrorState(colors: colors, typography: typography),
      ),
    );
  }
}

class _GeneratingState extends StatelessWidget {
  final AppThemeColors colors;
  final AppTypography typography;

  const _GeneratingState({required this.colors, required this.typography});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.success100,
            ),
          ),
          const SizedBox(height: 24),
          Text('Generating ZK Proof...', style: typography.h6),
          const SizedBox(height: 8),
          Text(
            'Creating a zero-knowledge proof\nfor your credential',
            style: typography.body1.copyWith(color: colors.secondaryText),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProofReadyState extends StatelessWidget {
  final Map<String, dynamic> proof;
  final Credential credential;
  final AppThemeColors colors;
  final AppTypography typography;

  const _ProofReadyState({
    required this.proof,
    required this.credential,
    required this.colors,
    required this.typography,
  });

  @override
  Widget build(BuildContext context) {
    final circuitType = proof['circuit_type'] as String? ?? 'unknown';
    final zkProof = proof['zk_proof'] as String? ?? '';
    final publicInputs = proof['public_inputs'] as Map<String, dynamic>? ?? {};

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.success100.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.success100.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Icon(Icons.verified, size: 48, color: AppColors.success100),
                const SizedBox(height: 12),
                Text('Proof Ready', style: typography.h4.copyWith(color: AppColors.success100)),
                const SizedBox(height: 4),
                Text(
                  'Zero-knowledge proof generated',
                  style: typography.body1.copyWith(color: colors.secondaryText),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Circuit', style: typography.info1.copyWith(color: colors.secondaryText)),
          const SizedBox(height: 4),
          Text(circuitType, style: typography.body3),
          const SizedBox(height: 16),
          Text('Credential', style: typography.info1.copyWith(color: colors.secondaryText)),
          const SizedBox(height: 4),
          Text(credential.displayType, style: typography.body3),
          const SizedBox(height: 24),
          Text('Public Inputs', style: typography.h8),
          const SizedBox(height: 8),
          ...publicInputs.entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        e.key,
                        style: typography.info2.copyWith(color: colors.secondaryText),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        e.value.toString(),
                        style: typography.info2.copyWith(fontFamily: 'monospace'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 24),
          Text('Proof Data', style: typography.h8),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.secondaryBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.dividerMedium),
            ),
            child: Text(
              zkProof.length > 80 ? '${zkProof.substring(0, 80)}...' : zkProof,
              style: typography.info2.copyWith(fontFamily: 'monospace', color: colors.text),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                final qrPayload = jsonEncode({
                  'type': 'logpass_proof',
                  'credential_id': credential.id,
                  'credential_type': credential.type,
                  'zk_proof': proof['zk_proof'],
                  'zk_public_inputs': proof['zk_public_inputs'],
                  'circuit_type': proof['circuit_type'],
                });
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Scan to Verify'),
                    content: SizedBox(
                      width: 280,
                      height: 280,
                      child: Center(
                        child: QrImageView(
                          data: qrPayload,
                          version: QrVersions.auto,
                          size: 250,
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.qr_code),
              label: Text('Show QR Code', style: typography.h8.copyWith(color: colors.buttonFilledText)),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.buttonFill,
                foregroundColor: colors.buttonFilledText,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final AppThemeColors colors;
  final AppTypography typography;

  const _ErrorState({required this.colors, required this.typography});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error100),
          const SizedBox(height: 16),
          Text('Proof Generation Failed', style: typography.h6),
          const SizedBox(height: 8),
          Text(
            'Could not generate the ZK proof.\nPlease try again.',
            style: typography.body1.copyWith(color: colors.secondaryText),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
