import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/one_time_code/one_time_code.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/one_time_code_container/one_time_code_container_cubit.dart';
import 'package:logpass_me/presentation/utils/date_time_utils.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

const _progressIndicatorHeight = 5.0;
// TODO: remove after appTypography implementation
const _customFontSize = 12.0;

class OneTimeCodeContainer extends HookWidget {
  bool _shouldBuild(OneTimeCodeContainerState state) => state is LoadInProgress || state is Idle || state is Error;

  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<OneTimeCodeContainerCubit>();
    final state = useCubitBuilder(cubit, buildWhen: _shouldBuild);
    final appColors = useAppThemeColors();

    useEffect(() {
      cubit.init();
      return;
    }, [cubit]);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: appColors.primaryButton,
        ),
        borderRadius: BorderRadius.circular(AppDimens.m),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: AppDimens.m,
        horizontal: AppDimens.xxxl,
      ),
      child: state.maybeWhen(
        idle: (oneTimeCode, remainingProgress) => _CodeContainer(
          oneTimeCode: oneTimeCode,
          remainingProgress: remainingProgress,
          onRefreshAction: cubit.refreshOneTimeCode,
          onCopyAction: cubit.copyOneTimeCodeToClipboard,
        ),
        loadInProgress: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: () => _CodeContainer(
          oneTimeCode: null,
          remainingProgress: null,
          onRefreshAction: cubit.refreshOneTimeCode,
          onCopyAction: cubit.copyOneTimeCodeToClipboard,
        ),
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }
}

class _CodeContainer extends HookWidget {
  final OneTimeCode? oneTimeCode;
  final double? remainingProgress;
  final VoidCallback onRefreshAction;
  final VoidCallback onCopyAction;
  final bool hasErrors;

  const _CodeContainer({
    required this.onRefreshAction,
    required this.onCopyAction,
    this.oneTimeCode,
    this.remainingProgress,
  }) : hasErrors = oneTimeCode == null;

  @override
  Widget build(BuildContext context) {
    final appTypography = useAppTypography();
    final appColors = useAppThemeColors();

    return Column(
      children: [
        Text(
          oneTimeCode?.code ?? LocaleKeys.home_codeErrorPlaceholder.tr(),
          style: appTypography.primary.copyWith(
            fontSize: AppDimens.xxl,
            fontWeight: FontWeight.w700,
          ),
        ),
        Visibility(
          visible: !hasErrors,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppDimens.xs),
              LinearProgressIndicator(
                value: remainingProgress,
                backgroundColor: appColors.secondary.withOpacity(0.7),
                valueColor: AlwaysStoppedAnimation(appColors.primaryButton),
                minHeight: _progressIndicatorHeight,
              ),
              const SizedBox(height: AppDimens.s),
              Text(
                LocaleKeys.home_activeInfo.tr(args: ['${oneTimeCode?.expirationTime.toCountdown()}']),
                style: appTypography.primary.copyWith(
                  fontSize: _customFontSize,
                  color: appColors.primaryButton,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.m),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _IconTextButton(
              LocaleKeys.home_copyCodeLabel.tr(),
              Icon(
                Icons.copy,
                color: appColors.primaryButton,
              ),
              onTapAction: onCopyAction,
              isActive: !hasErrors,
            ),
            _IconTextButton(
              LocaleKeys.home_refreshCodeLabel.tr(),
              Icon(
                Icons.history,
                color: appColors.primaryButton,
              ),
              onTapAction: onRefreshAction,
              isActive: !hasErrors,
            ),
          ],
        )
      ],
    );
  }
}

class _IconTextButton extends HookWidget {
  final String label;
  final Widget icon;
  final VoidCallback onTapAction;
  final bool isActive;

  const _IconTextButton(
    this.label,
    this.icon, {
    required this.onTapAction,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final appTypography = useAppTypography();
    final appColors = useAppThemeColors();

    return InkWell(
      onTap: isActive ? onTapAction : null,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: AppDimens.xs),
            Text(
              label,
              style: appTypography.primary.copyWith(
                color: appColors.primaryButton,
                fontSize: _customFontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
