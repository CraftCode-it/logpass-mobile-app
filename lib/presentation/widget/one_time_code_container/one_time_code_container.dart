import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/one_time_code/one_time_code.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/utils/date_time_utils.dart';
import 'package:logpass_me/presentation/widget/checkbox/loader.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/one_time_code_container/one_time_code_container_cubit.dart';

class OneTimeCodeContainer extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<OneTimeCodeContainerCubit>();
    final state = useCubitBuilder(cubit);

    useEffect(() {
      cubit.init();
      return;
    }, [cubit]);

    final size = MediaQuery.of(context).size.width * AppDimens.oneTimeCodeSizeFactor;

    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      padding: const EdgeInsets.symmetric(vertical: AppDimens.xxl),
      child: state.maybeWhen(
        idle: (oneTimeCode, remainingProgress) => _CodeContainer(
          oneTimeCode: oneTimeCode,
          remainingProgress: remainingProgress,
          onRefreshAction: cubit.refreshOneTimeCode,
          onCopyAction: cubit.copyOneTimeCodeToClipboard,
          progressSize: size,
        ),
        loadInProgress: () => SizedBox(
          width: size,
          height: size,
          child: const Loader(),
        ),
        error: () => _CodeContainer(
          oneTimeCode: null,
          remainingProgress: null,
          onRefreshAction: cubit.refreshOneTimeCode,
          onCopyAction: cubit.copyOneTimeCodeToClipboard,
          progressSize: size,
        ),
        orElse: () => SizedBox(
          width: size,
          height: size,
        ),
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
  final double progressSize;

  const _CodeContainer({
    required this.onRefreshAction,
    required this.onCopyAction,
    required this.progressSize,
    this.oneTimeCode,
    this.remainingProgress,
  }) : hasErrors = oneTimeCode == null;

  @override
  Widget build(BuildContext context) {
    final appTypography = useAppTypography();
    final colors = useAppThemeColors();

    return Stack(
      fit: StackFit.loose,
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: progressSize,
          height: progressSize,
          child: CircularProgressIndicator(
            value: 1.0,
            strokeWidth: AppDimens.oneTimeCodeProgressWidth,
            color: AppColors.secondary.withOpacity(0.15),
          ),
        ),
        SizedBox(
          width: progressSize,
          height: progressSize,
          child: RotatedBox(
            quarterTurns: 2,
            child: CircularProgressIndicator(
              value: remainingProgress,
              strokeWidth: AppDimens.oneTimeCodeProgressWidth,
              color: AppColors.success100,
            ),
          ),
        ),
        SizedBox(
          width: progressSize,
          height: progressSize,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppDimens.s),
                      child: Text(
                        LocaleKeys.home_activeInfo.tr(args: ['${oneTimeCode?.expirationTime.toCountdown()}']),
                        style: appTypography.info2.copyWith(color: colors.textSpecial),
                      ),
                    ),
                    const SizedBox(height: AppDimens.m),
                    Text(
                      oneTimeCode?.code ?? LocaleKeys.home_codeErrorPlaceholder.tr(),
                      style: appTypography.h1.copyWith(color: colors.textSpecial),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Center(
                  child: _IconTextButton(
                    LocaleKeys.home_copyCodeLabel.tr(),
                    Icon(
                      Icons.copy,
                      color: colors.logoSpecial,
                    ),
                    onTapAction: onCopyAction,
                    isActive: !hasErrors,
                  ),
                ),
              ),
            ],
          ),
        ),
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
              style: appTypography.info2.copyWith(
                color: appColors.textSpecial,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
