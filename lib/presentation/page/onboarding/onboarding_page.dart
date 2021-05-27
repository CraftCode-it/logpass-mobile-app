import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/generated/local_keys.g.dart';
import 'package:logpass_me/presentation/page/onboarding/onboarding_step.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/widget/rounded_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends HookWidget {
  static const _lastPageIndex = 2;

  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final controller = usePageController();
    final onboardingSteps = useMemoized(
      () => [
        OnboardingStep(
          image: Image.network('http://www.automotoszlif.pl/wp-content/uploads/2015/12/default-placeholder.png'),
          title: tr(LocaleKeys.onboarding_stepOneTitle),
          content: tr(LocaleKeys.onboarding_stepOneContent),
        ),
        OnboardingStep(
          image: Image.network('http://www.automotoszlif.pl/wp-content/uploads/2015/12/default-placeholder.png'),
          title: tr(LocaleKeys.onboarding_stepTwoTitle),
          content: tr(LocaleKeys.onboarding_stepTwoContent),
        ),
        OnboardingStep(
          image: Image.network('http://www.automotoszlif.pl/wp-content/uploads/2015/12/default-placeholder.png'),
          title: tr(LocaleKeys.onboarding_stepThreeTitle),
          content: tr(LocaleKeys.onboarding_stepThreeContent),
        ),
      ],
    );
    final index = useState(0);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSkippButton(index),
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
                startPressed: _navigateToLoginPage,
              ),
              const SizedBox(height: AppDimens.l),
              Center(
                child: SmoothPageIndicator(
                  controller: controller,
                  count: onboardingSteps.length,
                  effect: SlideEffect(
                    activeDotColor: colors.secondary,
                    dotColor: colors.secondary.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Visibility _buildSkippButton(ValueNotifier<int> index) => Visibility(
        visible: index.value != _lastPageIndex,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              LocaleKeys.common_skip,
            ).tr(),
          ),
        ),
      );

  void _navigateToLoginPage() {}
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
          ? RoundedButton(
              text: tr(LocaleKeys.common_next),
              onPressed: nextPressed,
            )
          : RoundedButton(
              text: tr(LocaleKeys.common_start),
              onPressed: startPressed,
            ),
    );
  }
}
