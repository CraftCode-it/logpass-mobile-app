import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/core/crypto/key_provider.dart';
import 'package:logpass_me/core/di/di_config.dart';
import 'package:logpass_me/data/wallet/wallet_api_data_source.dart';
import 'package:logpass_me/domain/wallet/wallet_repository.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

@RoutePage()
class VerificationRequestPage extends HookWidget {
  final String? requestId;
  final String? verifierName;
  final String? requestType;
  final int? minAge;

  const VerificationRequestPage({
    Key? key,
    this.requestId,
    this.verifierName,
    this.requestType,
    this.minAge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();
    final isProcessing = useState(false);
    final resultMessage = useState<String?>(null);
    final isSuccess = useState(false);

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
        child: resultMessage.value != null
            ? _ResultView(
                message: resultMessage.value!,
                success: isSuccess.value,
                colors: colors,
                typography: typography,
                onDone: () => Navigator.of(context).pop(true),
              )
            : Column(
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
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: colors.buttonOutlined),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text('Decline', style: typography.h8.copyWith(color: colors.buttonOutlinedText)),
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
                                : () => _approve(
                                      isProcessing: isProcessing,
                                      resultMessage: resultMessage,
                                      isSuccess: isSuccess,
                                    ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success100,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: isProcessing.value
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : Text('Approve', style: typography.h8.copyWith(color: Colors.white)),
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

  Future<void> _approve({
    required ValueNotifier<bool> isProcessing,
    required ValueNotifier<String?> resultMessage,
    required ValueNotifier<bool> isSuccess,
  }) async {
    isProcessing.value = true;
    try {
      final keyProvider = getIt<KeyProvider>();
      final repo = getIt<WalletRepository>();
      final api = getIt<WalletApiDataSource>();

      final pubkey = await keyProvider.getUserPubkeyHex();

      final credential = await repo.requestAgeVerification(
        userPubkey: pubkey,
        minAge: minAge ?? 18,
      );

      final proof = await repo.generateProof(credential.id);

      if (requestId != null) {
        await api.fulfillRequest(
          requestId: requestId!,
          zkProof: proof['zk_proof'] as String? ?? '',
          zkPublicInputs: (proof['zk_public_inputs'] is List)
              ? (proof['zk_public_inputs'] as List).map((e) => e.toString()).toList()
              : <String>[],
        );
      }

      isSuccess.value = true;
      resultMessage.value = 'Verification approved!\nZK proof shared with ${verifierName ?? 'verifier'}.';
    } catch (e) {
      isSuccess.value = false;
      resultMessage.value = 'Verification failed:\n$e';
    } finally {
      isProcessing.value = false;
    }
  }
}

class _ResultView extends StatelessWidget {
  final String message;
  final bool success;
  final AppThemeColors colors;
  final AppTypography typography;
  final VoidCallback onDone;

  const _ResultView({
    required this.message,
    required this.success,
    required this.colors,
    required this.typography,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            success ? Icons.check_circle : Icons.error_outline,
            size: 80,
            color: success ? AppColors.success100 : AppColors.error100,
          ),
          const SizedBox(height: 24),
          Text(
            success ? 'Success' : 'Failed',
            style: typography.h3.copyWith(
              color: success ? AppColors.success100 : AppColors.error100,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: typography.body1.copyWith(color: colors.secondaryText),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 200,
            height: 48,
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.buttonFill,
                foregroundColor: colors.buttonFilledText,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Done', style: typography.h8.copyWith(color: colors.buttonFilledText)),
            ),
          ),
        ],
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
