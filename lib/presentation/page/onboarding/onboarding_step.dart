import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

class OnboardingStep extends HookWidget {
  final Widget image;
  final String title;
  final String content;

  const OnboardingStep({
    required this.image,
    required this.title,
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: image),
        const SizedBox(height: AppDimens.l),
        Text(
          title,
          textAlign: TextAlign.center,
          style: typography.primary,
        ),
        const SizedBox(height: AppDimens.l),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
          child: Text(
            content,
            textAlign: TextAlign.center,
            style: typography.primary.copyWith(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
