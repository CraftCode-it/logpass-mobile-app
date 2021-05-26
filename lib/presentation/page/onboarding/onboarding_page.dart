import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/core/di/di_config.dart';
import 'package:logpass_me/domain/theme/theme_brightness.dart';
import 'package:logpass_me/domain/theme/use_case/set_theme_brightness_use_case.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

class OnboardingPage extends HookWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    final brightness = Theme.of(context).brightness;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hello',
                style: typography.primary,
              ),
              Switch(
                value: brightness == Brightness.dark,
                onChanged: (val) {
                  getIt<SetThemeBrightnessUseCase>()(val ? ThemeBrightness.dark : ThemeBrightness.light);
                },
                activeColor: colors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
