import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/wallet/credential.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/guardian/guardian_page.dart';
import 'package:logpass_me/presentation/page/wallet/wallet_home/wallet_home_cubit.dart';
import 'package:logpass_me/presentation/routing/main_router.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

@RoutePage()
class WalletHomePage extends HookWidget {
  static final reloadNotifier = ValueNotifier<int>(0);

  const WalletHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<WalletHomeCubit>();
    final state = useCubitBuilder(cubit);
    final colors = useAppThemeColors();
    final typography = useAppTypography();
    final reloadKey = useValueListenable(WalletHomePage.reloadNotifier);

    useEffect(() {
      cubit.loadCredentials();
      return;
    }, [cubit, reloadKey]);

    final isMinor = state is WalletHomeLoaded && state.isMinor;
    final hasAge18Credential = state is WalletHomeLoaded &&
        state.credentials.any((c) => c.type == 'age_18' && c.result == true);

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
                Text(LocaleKeys.wallet_title.tr(), style: typography.h3),
                _ServiceIndicator(
                  online: state is WalletHomeLoaded && state.serviceOnline,
                  colors: colors,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              LocaleKeys.wallet_subtitle.tr(),
              style: typography.body1.copyWith(color: colors.secondaryText),
            ),
            const SizedBox(height: 24),
            if (!isMinor || hasAge18Credential)
              _VerifyAgeButton(
                colors: colors,
                typography: typography,
                isLoading: state is WalletHomeVerifying || state is WalletHomeLoading,
                onPressed: () => cubit.requestVerification(),
              )
            else ...[
              _MinorWarningSection(
                colors: colors,
                typography: typography,
                isLoading: state is WalletHomeVerifying || state is WalletHomeLoading,
                onForcedVerify: () => _showForcedVerifyDialog(context, cubit),
                onGuardians: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const GuardianPage()),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(LocaleKeys.wallet_credentialsLabel.tr(), style: typography.h8),
            const SizedBox(height: 12),
            Expanded(child: _buildBody(state, colors, typography, context)),
          ],
        ),
      ),
    );
  }

  Future<void> _showForcedVerifyDialog(BuildContext context, WalletHomeCubit cubit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Uwaga — weryfikacja wieku'),
        content: const Text(
          'Twój wiek wskazuje, że masz mniej niż 18 lat. '
          'Wymuś poświadczenie tylko jeśli jesteś pewien swojego wieku lub '
          'masz zgodę opiekuna. Poświadczenie zostanie odrzucone podczas weryfikacji.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Anuluj'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Wymuś poświadczenie'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      cubit.requestForcedVerification();
    }
  }

  Widget _buildBody(
    WalletHomeState state,
    AppThemeColors colors,
    AppTypography typography,
    BuildContext context,
  ) {
    if (state is WalletHomeLoading || state is WalletHomeInitial) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is WalletHomeVerifying) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is WalletHomeError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error100),
            const SizedBox(height: 12),
            Text(
              LocaleKeys.wallet_errorGeneral.tr(),
              style: typography.body1.copyWith(color: colors.secondaryText),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    if (state is WalletHomeLoaded) {
      if (state.credentials.isEmpty) {
        return _EmptyState(colors: colors, typography: typography);
      }
      return ListView.separated(
        itemCount: state.credentials.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _CredentialCard(
            credential: state.credentials[index],
            colors: colors,
            typography: typography,
            onTap: () {
              AutoRouter.of(context).push(
                CredentialDetailRoute(credential: state.credentials[index]),
              );
            },
          );
        },
      );
    }
    return const SizedBox.shrink();
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
          online ? LocaleKeys.wallet_statusOnline.tr() : LocaleKeys.wallet_statusOffline.tr(),
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
                  Text(LocaleKeys.wallet_verifyAge.tr(), style: typography.h8.copyWith(color: colors.buttonFilledText)),
                ],
              ),
      ),
    );
  }
}

class _MinorWarningSection extends StatelessWidget {
  final AppThemeColors colors;
  final AppTypography typography;
  final bool isLoading;
  final VoidCallback onForcedVerify;
  final VoidCallback onGuardians;

  const _MinorWarningSection({
    required this.colors,
    required this.typography,
    required this.isLoading,
    required this.onForcedVerify,
    required this.onGuardians,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.child_care, color: AppColors.warning, size: 20),
              const SizedBox(width: 8),
              Text(
                'Konto osoby niepełnoletniej',
                    style: typography.h8.copyWith(color: AppColors.warning),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Wykryto, że masz mniej niż 18 lat. '
            'Dodaj opiekuna, który może autoryzować Twoje weryfikacje.',
            style: typography.body2.copyWith(color: colors.secondaryText),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: isLoading ? null : onForcedVerify,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.warning),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.warning_amber, size: 18, color: AppColors.warning),
                    label: Text(
                      'Wymuś wiek 18+',
                      style: typography.body2.copyWith(color: AppColors.warning),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: onGuardians,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.buttonFill,
                      foregroundColor: colors.buttonFilledText,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    icon: Icon(Icons.supervisor_account, size: 18, color: colors.buttonFilledText),
                    label: Text(
                      'Opiekunowie',
                      style: typography.body2.copyWith(color: colors.buttonFilledText),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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
            LocaleKeys.wallet_emptyTitle.tr(),
            style: typography.h7.copyWith(color: colors.secondaryText),
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.wallet_emptySubtitle.tr(),
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
                    credential.isValid
                        ? LocaleKeys.wallet_credentialValid.tr()
                        : LocaleKeys.wallet_credentialExpired.tr(),
                    style: typography.info2.copyWith(
                      color: credential.isValid ? AppColors.success100 : AppColors.error100,
                    ),
                  ),
                ],
              ),
            ),
            if (credential.isAnchored)
              Tooltip(
                message: LocaleKeys.wallet_credentialAnchored.tr(),
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
