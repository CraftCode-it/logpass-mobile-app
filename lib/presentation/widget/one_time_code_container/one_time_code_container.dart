import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/domain/one_time_code/one_time_code.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/utils/date_time_utils.dart';
import 'package:logpass_me/presentation/utils/text_utils.dart';
import 'package:logpass_me/presentation/widget/cubit_hooks.dart';
import 'package:logpass_me/presentation/widget/one_time_code_container/one_time_code_container_cubit.dart';

const _copyIconSize = 20.0;

class OneTimeCodeContainer extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = useCubit<OneTimeCodeContainerCubit>();
    final state = useCubitBuilder(cubit);
    final colors = useAppThemeColors();

    useEffect(() {
      cubit.init();
      return;
    }, [cubit]);

    final size = MediaQuery.of(context).size.width * AppDimens.oneTimeCodeSizeFactor;

    return Container(
      width: double.infinity,
      color: colors.darkBackground,
      padding: const EdgeInsets.symmetric(vertical: AppDimens.xxl),
      child: state.maybeWhen(
        idle: (oneTimeCode, remainingProgress) => _CodeContainer(
          key: ValueKey(oneTimeCode),
          oneTimeCode: oneTimeCode,
          remainingProgress: remainingProgress,
          onRefreshAction: cubit.refreshOneTimeCode,
          onCopyAction: cubit.copyOneTimeCodeToClipboard,
          progressSize: size,
        ),
        loadInProgress: () => _CodeContainer(
          oneTimeCode: null,
          remainingProgress: null,
          onRefreshAction: null,
          onCopyAction: null,
          progressSize: size,
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
  final VoidCallback? onRefreshAction;
  final VoidCallback? onCopyAction;
  final bool hasErrors;
  final double progressSize;

  const _CodeContainer({
    required this.onRefreshAction,
    required this.onCopyAction,
    required this.progressSize,
    this.oneTimeCode,
    this.remainingProgress,
    Key? key,
  })  : hasErrors = oneTimeCode == null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTypography = useAppTypography();
    final colors = useAppThemeColors();
    final inactiveColor = colors.textSpecial.withOpacity(0.15);

    final controller = useAnimationController(duration: oneTimeCode?.expirationSec ?? Duration.zero);
    final animation = ColorTween(begin: AppColors.success100, end: AppColors.error100).animate(controller);
    useAnimation(animation);

    useMemoized(() {
      controller.forward();
    });

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
            child: oneTimeCode == null
                ? const CircularProgressIndicator(
                    strokeWidth: AppDimens.oneTimeCodeProgressWidth,
                    color: AppColors.success100,
                  )
                : CircularProgressIndicator(
                    value: remainingProgress,
                    strokeWidth: AppDimens.oneTimeCodeProgressWidth,
                    valueColor: animation,
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
                flex: 4,
                child: TextButton(
                  onPressed: onRefreshAction,
                  child: Text(
                    LocaleKeys.home_refreshCodeLabel,
                    style: appTypography.info1.copyWith(
                      color: hasErrors ? inactiveColor : colors.textSpecial,
                    ),
                  ).tr().withUnderline(hasErrors ? inactiveColor : colors.textSpecial),
                ),
              ),
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!hasErrors)
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
                      style: appTypography.h1.copyWith(color: hasErrors ? inactiveColor : colors.textSpecial),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: _IconTextButton(
                  LocaleKeys.home_copyCodeLabel.tr(),
                  Icon(
                    Icons.copy,
                    color: hasErrors ? inactiveColor : colors.logoSpecial,
                    size: _copyIconSize,
                  ),
                  onTapAction: onCopyAction,
                  isActive: !hasErrors,
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
  final VoidCallback? onTapAction;
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
    final color = isActive ? appColors.textSpecial : appColors.textSpecial.withOpacity(0.15);

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
              style: appTypography.info1.copyWith(
                color: color,
                // decoration: TextDecoration.underline,
              ),
            ).withUnderline(color),
          ],
        ),
      ),
    );
  }
}
