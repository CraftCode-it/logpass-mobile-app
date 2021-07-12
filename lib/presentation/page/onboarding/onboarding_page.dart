import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/onboarding/onboarding_step.dart';
import 'package:logpass_me/presentation/routing/main_router.gr.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';
import 'package:logpass_me/presentation/widget/page_indicator.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';

class OnboardingPage extends HookWidget {
  static const _lastPageIndex = 2;

  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors = useAppThemeColors();
    final controller = usePageController();
    final onboardingSteps = useMemoized(
      () => [
        OnboardingStep(
          image: SvgPicture.asset(
            brightness == Brightness.light ? AppIcon.onboarding1Light : AppIcon.onboarding1Dark,
            alignment: Alignment.topCenter,
          ),
          title: tr(LocaleKeys.onboarding_stepOneTitle),
          content: tr(LocaleKeys.onboarding_stepOneContent),
        ),
        OnboardingStep(
          image: SvgPicture.asset(
            brightness == Brightness.light ? AppIcon.onboarding2Light : AppIcon.onboarding2Dark,
            alignment: Alignment.topCenter,
          ),
          title: tr(LocaleKeys.onboarding_stepTwoTitle),
          content: tr(LocaleKeys.onboarding_stepTwoContent),
        ),
        OnboardingStep(
          image: SvgPicture.asset(
            brightness == Brightness.light ? AppIcon.onboarding3Light : AppIcon.onboarding3Dark,
            alignment: Alignment.topCenter,
          ),
          title: tr(LocaleKeys.onboarding_stepThreeTitle),
          content: tr(LocaleKeys.onboarding_stepThreeContent),
        ),
      ],
    );
    final index = useState(0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: colors.darkBackground,
        body: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SkipButton(
                  index: index.value,
                  onSkip: _navigateToLoginPage,
                ),
                const SizedBox(height: AppDimens.xxl),
                Expanded(
                  child: PageView(
                    controller: controller,
                    onPageChanged: (page) => index.value = page,
                    children: onboardingSteps,
                  ),
                ),
                const SizedBox(height: AppDimens.xxl),
                _NavigationButton(
                  page: index.value,
                  nextPressed: () => controller.nextPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  ),
                  startPressed: () => _navigateToLoginPage(context),
                ),
                const SizedBox(height: AppDimens.l),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(
                      onboardingSteps.length,
                      (indicatorIndex) => PageIndicator(
                        isActive: index.value == indicatorIndex,
                        activeColor: AppColors.secondary,
                        inactiveColor: AppColors.secondary.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.m),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToLoginPage(BuildContext context) => AutoRouter.of(context).replace(const StartPageRoute());
}

class _SkipButton extends HookWidget {
  final int index;
  final Function(BuildContext context) onSkip;

  const _SkipButton({
    required this.index,
    required this.onSkip,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return Visibility(
      visible: index != OnboardingPage._lastPageIndex,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () => onSkip(context),
          child: Text(
            LocaleKeys.common_skip,
            style: typography.body2.copyWith(color: AppColors.lightTextDark),
          ).tr(),
        ),
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final int page;
  final Function() nextPressed;
  final Function() startPressed;

  const _NavigationButton({
    required this.page,
    required this.nextPressed,
    required this.startPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: page != OnboardingPage._lastPageIndex
          ? CustomRectangularButton.filled(
              text: tr(LocaleKeys.common_next),
              onPressed: nextPressed,
              fillColor: AppColors.buttonFillDark,
              textColor: AppColors.buttonFilledTextDark,
            )
          : CustomRectangularButton.filled(
              text: tr(LocaleKeys.common_start),
              onPressed: startPressed,
              fillColor: AppColors.buttonFillDark,
              textColor: AppColors.buttonFilledTextDark,
            ),
    );
  }
}
