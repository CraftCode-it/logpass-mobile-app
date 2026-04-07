import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/identity/identity_profile.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/guardian/guardian_authorization_dialog.dart';
import 'package:logpass_me/presentation/page/wallet/verification_request/verification_request_cubit.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/hooks/cubit_hooks.dart';

@RoutePage()
class VerificationRequestPage extends HookWidget {
  final String? requestId;
  final String? verifierName;
  final String? requestType;
  final int? minAge;
  final bool allowGuardian;

  const VerificationRequestPage({
    Key? key,
    this.requestId,
    this.verifierName,
    this.requestType,
    this.minAge,
    this.allowGuardian = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();
    final cubit = useCubit<VerificationRequestCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(() {
      cubit.initialize();
      return null;
    }, [cubit]);

    useCubitListener<VerificationRequestCubit, VerificationRequestState>(
      cubit,
      (_, st, ctx) => _onStateChange(ctx, cubit, st),
    );

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: colors.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(LocaleKeys.verificationRequest_title.tr(), style: typography.h6.copyWith(color: colors.text)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _buildBody(context, cubit, state, colors, typography),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    VerificationRequestCubit cubit,
    VerificationRequestState state,
    AppThemeColors colors,
    AppTypography typography,
  ) {
    if (state is VerificationRequestSuccess) {
      return _ResultView(
        message: state.message,
        success: true,
        colors: colors,
        typography: typography,
        onDone: () => Navigator.of(context).pop(true),
      );
    }

    if (state is VerificationRequestFailure &&
        state.message != '__guardian_required__') {
      return _ResultView(
        message: state.message,
        success: false,
        colors: colors,
        typography: typography,
        onDone: () => Navigator.of(context).pop(),
      );
    }

    final isProcessing = state is VerificationRequestProcessing;
    final List<IdentityProfile> profiles = state is VerificationRequestIdle ? state.profiles : const [];
    final selectedId =
        state is VerificationRequestIdle ? state.selectedProfileId : null;
    final isMinor = state is VerificationRequestIdle ? state.isMinor : false;
    final isAgeRequest = requestType == 'age_18' || requestType == 'identity_and_age' || requestType == null;

    return SingleChildScrollView(
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
                Text(verifierName ?? LocaleKeys.verificationRequest_unknownVerifier.tr(), style: typography.h4),
                const SizedBox(height: 8),
                Text(
                  LocaleKeys.verificationRequest_requestsVerification.tr(),
                  style: typography.body1.copyWith(color: colors.secondaryText),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _RequestDetail(
            icon: Icons.verified_user,
            title: LocaleKeys.verificationRequest_verificationType.tr(),
            value: requestType == 'identity'
                ? LocaleKeys.verificationRequest_typeIdentity.tr()
                : requestType == 'age_18'
                    ? LocaleKeys.verificationRequest_typeAge18.tr()
                    : requestType == 'identity_and_age'
                        ? 'Tożsamość i wiek 18+'
                        : requestType ?? LocaleKeys.verificationRequest_typeAgeGeneric.tr(),
            colors: colors,
            typography: typography,
          ),
          if (requestType != 'identity') ...[
            const SizedBox(height: 16),
            _RequestDetail(
              icon: Icons.cake,
              title: LocaleKeys.verificationRequest_minAge.tr(),
              value: LocaleKeys.verificationRequest_minAgeValue.tr(namedArgs: {'age': '${minAge ?? 18}'}),
              colors: colors,
              typography: typography,
            ),
          ],
          const SizedBox(height: 16),
          _RequestDetail(
            icon: Icons.privacy_tip,
            title: LocaleKeys.verificationRequest_sharedData.tr(),
            value: requestType == 'identity'
                ? LocaleKeys.verificationRequest_sharedDataIdentity.tr()
                : LocaleKeys.verificationRequest_sharedDataZk.tr(),
            colors: colors,
            typography: typography,
          ),
          const SizedBox(height: 24),
          if (state is VerificationRequestIdle && profiles.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: LinearProgressIndicator(),
            )
          else if (profiles.isNotEmpty)
            _ProfilePicker(
              profiles: profiles,
              selectedId: selectedId,
              onSelected: cubit.selectProfile,
              colors: colors,
              typography: typography,
            ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: isProcessing ? null : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colors.buttonOutlined),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      LocaleKeys.verificationRequest_deny.tr(),
                      style: typography.h8.copyWith(color: colors.buttonOutlinedText),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isProcessing
                        ? null
                        : () {
                            if (requestType == 'identity') {
                              cubit.approveIdentityVerification(
                                requestId: requestId,
                                verifierName: verifierName,
                              );
                            } else {
                              cubit.approveAgeVerification(
                                requestId: requestId,
                                verifierName: verifierName,
                                minAge: minAge,
                                allowGuardian: allowGuardian,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isMinor && isAgeRequest
                          ? (allowGuardian ? AppColors.warning : AppColors.error100)
                          : AppColors.success100,
                      foregroundColor: colors.buttonFilledText,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: isProcessing
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: colors.buttonFilledText),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isMinor && isAgeRequest && allowGuardian) ...[
                                const Icon(Icons.supervisor_account, size: 18),
                                const SizedBox(width: 6),
                              ],
                              Text(
                                isMinor && isAgeRequest
                                    ? (allowGuardian
                                        ? LocaleKeys.verificationRequest_askGuardian.tr()
                                        : LocaleKeys.verificationRequest_underageReject.tr())
                                    : LocaleKeys.verificationRequest_approve.tr(),
                                style: typography.h8.copyWith(color: colors.buttonFilledText),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _onStateChange(
    BuildContext context,
    VerificationRequestCubit cubit,
    VerificationRequestState state,
  ) async {
    if (state is VerificationRequestSuccess) {
      Future.delayed(const Duration(seconds: 3), () {
        if (context.mounted) {
          Navigator.of(context).pop(true);
        }
      });
    }
    if (state is VerificationRequestFailure &&
        state.message == '__guardian_required__') {
      final approved = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => GuardianAuthorizationDialog(
          serviceName: verifierName ?? LocaleKeys.verificationRequest_guardianServiceName.tr(),
          action: 'age_verification_${minAge ?? 18}',
          verifierName: verifierName,
        ),
      );
      if (approved == true) {
        await cubit.approveAgeVerification(
          requestId: requestId,
          verifierName: verifierName,
          minAge: minAge,
          guardianApproved: true,
          allowGuardian: allowGuardian,
        );
      } else {
        cubit.setGuardianDenied(minAge);
      }
    }
  }
}

// ─── Profile picker ─────────────────────────────────────────────────────────────
class _ProfilePicker extends StatelessWidget {
  final List<IdentityProfile> profiles;
  final String? selectedId;
  final void Function(String id) onSelected;
  final AppThemeColors colors;
  final AppTypography typography;

  const _ProfilePicker({
    required this.profiles,
    required this.selectedId,
    required this.onSelected,
    required this.colors,
    required this.typography,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.verificationRequest_profileLabel.tr(),
          style: typography.info2.copyWith(color: colors.secondaryText),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: profiles.map<Widget>((p) {
            final isSelected = p.id == selectedId;
            return GestureDetector(
              onTap: () => onSelected(p.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? colors.buttonFill : colors.secondaryBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? colors.buttonFill : colors.dividerMedium,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  p.displayName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? colors.buttonFilledText : colors.text,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
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
            success ? LocaleKeys.verificationRequest_success.tr() : LocaleKeys.verificationRequest_failure.tr(),
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
              child: Text(
                LocaleKeys.verificationRequest_done.tr(),
                style: typography.h8.copyWith(color: colors.buttonFilledText),
              ),
            ),
          ),
          if (success) ...[
            const SizedBox(height: 12),
            Text(
              LocaleKeys.verificationRequest_autoClose.tr(),
              style: typography.info2.copyWith(color: colors.secondaryText),
              textAlign: TextAlign.center,
            ),
          ],
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
