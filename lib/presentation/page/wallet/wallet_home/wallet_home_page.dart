import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/wallet/credential.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

@RoutePage()
class WalletHomePage extends HookWidget {
  const WalletHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();
    final credentials = useState<List<Credential>>([]);
    final isLoading = useState(false);
    final serviceOnline = useState(false);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Wallet', style: typography.h3),
                _ServiceIndicator(online: serviceOnline.value, colors: colors),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Your verifiable credentials',
              style: typography.body1.copyWith(color: colors.secondaryText),
            ),
            const SizedBox(height: 24),
            _VerifyAgeButton(
              colors: colors,
              typography: typography,
              isLoading: isLoading.value,
              onPressed: () {
                // Will trigger verification via cubit when wired
              },
            ),
            const SizedBox(height: 24),
            Text('Credentials', style: typography.h8),
            const SizedBox(height: 12),
            Expanded(
              child: isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : credentials.value.isEmpty
                      ? _EmptyState(colors: colors, typography: typography)
                      : ListView.separated(
                          itemCount: credentials.value.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return _CredentialCard(
                              credential: credentials.value[index],
                              colors: colors,
                              typography: typography,
                              onTap: () {
                                // Navigate to credential detail
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceIndicator extends StatelessWidget {
  final bool online;
  final AppThemeColors colors;

  const _ServiceIndicator({required this.online, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: online ? AppColors.success100 : AppColors.error100,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          online ? 'Online' : 'Offline',
          style: TextStyle(fontSize: 12, color: colors.secondaryText),
        ),
      ],
    );
  }
}

class _VerifyAgeButton extends StatelessWidget {
  final AppThemeColors colors;
  final AppTypography typography;
  final bool isLoading;
  final VoidCallback onPressed;

  const _VerifyAgeButton({
    required this.colors,
    required this.typography,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.buttonFill,
          foregroundColor: colors.buttonFilledText,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.buttonFilledText,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_user, size: 20, color: colors.buttonFilledText),
                  const SizedBox(width: 8),
                  Text('Verify Age (18+)', style: typography.h8.copyWith(color: colors.buttonFilledText)),
                ],
              ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AppThemeColors colors;
  final AppTypography typography;

  const _EmptyState({required this.colors, required this.typography});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_wallet_outlined, size: 64, color: colors.lightText),
          const SizedBox(height: 16),
          Text(
            'No credentials yet',
            style: typography.h7.copyWith(color: colors.secondaryText),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap "Verify Age" to get your first\nverifiable credential',
            style: typography.body1.copyWith(color: colors.lightText),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CredentialCard extends StatelessWidget {
  final Credential credential;
  final AppThemeColors colors;
  final AppTypography typography;
  final VoidCallback onTap;

  const _CredentialCard({
    required this.credential,
    required this.colors,
    required this.typography,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.dividerMedium),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: credential.isValid
                    ? AppColors.success100.withOpacity(0.1)
                    : AppColors.error100.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                credential.isValid ? Icons.check_circle : Icons.cancel,
                color: credential.isValid ? AppColors.success100 : AppColors.error100,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(credential.displayType, style: typography.h8),
                  const SizedBox(height: 4),
                  Text(
                    credential.isValid ? 'Valid' : 'Expired / Invalid',
                    style: typography.info2.copyWith(
                      color: credential.isValid ? AppColors.success100 : AppColors.error100,
                    ),
                  ),
                ],
              ),
            ),
            if (credential.isAnchored)
              Tooltip(
                message: 'Anchored on-chain',
                child: Icon(Icons.link, size: 20, color: AppColors.success100),
              ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, color: colors.lightText),
          ],
        ),
      ),
    );
  }
}
