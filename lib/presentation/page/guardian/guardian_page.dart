import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/core/di/di_config.dart';
import 'package:logpass_me/domain/guardian/guardian.dart';
import 'package:logpass_me/domain/identity/identity_field.dart';
import 'package:logpass_me/domain/identity/identity_profile_type.dart';
import 'package:logpass_me/domain/identity/identity_repository.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/guardian/guardian_cubit.dart';
import 'package:logpass_me/presentation/routing/main_router.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

@RoutePage()
class GuardianPage extends HookWidget {
  const GuardianPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<GuardianCubit>();
    final state = useCubitBuilder<GuardianCubit, GuardianState>(cubit);
    final colors = useAppThemeColors();
    final typography = useAppTypography();
    final isMinor = useState<bool>(false);

    useEffect(() {
      cubit.load();
      return null;
    }, [cubit]);

    useEffect(() {
      Future<void> detectMinor() async {
        try {
          final repo = getIt<IdentityRepository>();
          final profiles = await repo.getProfiles();
          final privateProfile = profiles
              .where((p) => p.type == IdentityProfileType.private)
              .firstOrNull;
          if (privateProfile == null) return;
          final dobField = privateProfile.fields
              .where((f) => f.key == IdentityFieldKey.dateOfBirth && f.value.isNotEmpty)
              .firstOrNull;
          if (dobField == null) return;
          final dob = DateTime.tryParse(dobField.value);
          if (dob == null) return;
          final now = DateTime.now();
          int age = now.year - dob.year;
          if (now.month < dob.month ||
              (now.month == dob.month && now.day < dob.day)) age--;
          isMinor.value = age < 18;
        } catch (_) {}
      }
      detectMinor();
      return null;
    }, const []);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text(LocaleKeys.guardian_title.tr(), style: typography.h2),
      ),
      body: _buildBody(context, state, cubit, colors, typography, isMinor.value),
    );
  }

  Widget _buildBody(
    BuildContext context,
    GuardianState state,
    GuardianCubit cubit,
    AppThemeColors colors,
    AppTypography typography,
    bool isMinor,
  ) {
    if (state is GuardianLoading || state is GuardianOperating) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is GuardianError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error100),
            const SizedBox(height: 12),
            Text(
              LocaleKeys.guardian_error.tr(namedArgs: {'message': state.message}),
              style: typography.body1.copyWith(color: colors.secondaryText),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: cubit.load,
              child: Text(LocaleKeys.guardian_retry.tr()),
            ),
          ],
        ),
      );
    }
    if (state is GuardianLoaded) {
      final guardians = state.myGuardians;
      final minors = state.myMinors;

      if (guardians.isEmpty && minors.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.l),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.supervisor_account_outlined, size: 64, color: colors.lightText),
                const SizedBox(height: 16),
                Text(
                  isMinor
                      ? LocaleKeys.guardian_noGuardians.tr()
                      : LocaleKeys.guardian_noDependants.tr(),
                  style: typography.h7.copyWith(color: colors.secondaryText),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  isMinor
                      ? LocaleKeys.guardian_scanGuardianHint.tr()
                      : LocaleKeys.guardian_scanMinorHint.tr(),
                  style: typography.body1.copyWith(color: colors.lightText),
                  textAlign: TextAlign.center,
                ),
                if (isMinor) ...[
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => AutoRouter.of(context).push(const GuardianShowQrRoute()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary100,
                      foregroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.qr_code, size: 20),
                    label: Text(
                      LocaleKeys.guardian_showQrTitle.tr(),
                      style: typography.h8.copyWith(color: AppColors.secondary),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }

      return ListView(
        padding: const EdgeInsets.all(AppDimens.l),
        children: [
          if (isMinor) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => AutoRouter.of(context).push(const GuardianShowQrRoute()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary100,
                  foregroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.qr_code, size: 20),
                label: Text(
                  LocaleKeys.guardian_showQrTitle.tr(),
                  style: typography.h8.copyWith(color: AppColors.secondary),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          if (guardians.isNotEmpty) ...[
            Text(LocaleKeys.guardian_myGuardians.tr(), style: typography.h6),
            const SizedBox(height: 8),
            ...guardians.map((g) => _GuardianCard(
                  guardian: g,
                  colors: colors,
                  typography: typography,
                  canApprove: g.isPending,
                  cubit: cubit,
                  showDependantLabel: false,
                )),
            const SizedBox(height: 24),
          ],
          if (minors.isNotEmpty) ...[
            Text(LocaleKeys.guardian_myDependants.tr(), style: typography.h6),
            const SizedBox(height: 8),
            ...minors.map((g) => _GuardianCard(
                  guardian: g,
                  colors: colors,
                  typography: typography,
                  canApprove: false,
                  cubit: cubit,
                  showDependantLabel: true,
                )),
          ],
        ],
      );
    }
    return const SizedBox.shrink();
  }
}

class _GuardianCard extends StatelessWidget {
  final Guardian guardian;
  final AppThemeColors colors;
  final AppTypography typography;
  final bool canApprove;
  final GuardianCubit cubit;
  final bool showDependantLabel;

  const _GuardianCard({
    required this.guardian,
    required this.colors,
    required this.typography,
    required this.canApprove,
    required this.cubit,
    this.showDependantLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusLabel;
    switch (guardian.status) {
      case 'active':
        statusColor = AppColors.success100;
        statusLabel = LocaleKeys.guardian_statusActive.tr();
        break;
      case 'pending':
        statusColor = AppColors.warning;
        statusLabel = LocaleKeys.guardian_statusPending.tr();
        break;
      default:
        statusColor = AppColors.error100;
        statusLabel = LocaleKeys.guardian_statusRevoked.tr();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(AppDimens.m),
      decoration: BoxDecoration(
        color: colors.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: canApprove ? AppColors.warning.withOpacity(0.5) : colors.dividerMedium,
          width: canApprove ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline, color: colors.secondaryText),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(guardian.displayName, style: typography.h8),
                    Text(
                      showDependantLabel
                          ? guardian.dependantLabel
                          : guardian.relationshipLabel,
                      style: typography.info2.copyWith(color: colors.lightText),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusLabel,
                  style: typography.info2.copyWith(color: statusColor),
                ),
              ),
            ],
          ),
          if (canApprove) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => cubit.rejectGuardian(guardian.id),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error100),
                      foregroundColor: AppColors.error100,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text(
                      LocaleKeys.guardianApproval_reject.tr(),
                      style: typography.body2.copyWith(color: AppColors.error100),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => cubit.confirmGuardian(guardian.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success100,
                      foregroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text(
                      LocaleKeys.guardian_approve.tr(),
                      style: typography.body2.copyWith(color: AppColors.secondary),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
