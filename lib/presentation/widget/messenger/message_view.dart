import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

class InfoMessage extends HookWidget {
  final String content;
  final Function() onDismiss;
  final String? action;
  final Function()? onAction;

  const InfoMessage({
    required this.content,
    required this.onDismiss,
    this.action,
    this.onAction,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    final action = this.action;

    return _MessageView(
      background: AppColors.success100,
      content: action == null
          ? Text(
              content,
              style: typography.input.copyWith(color: colors.textSpecial),
              textAlign: TextAlign.center,
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    content,
                    style: typography.input.copyWith(color: colors.textSpecial),
                  ),
                ),
                const SizedBox(width: AppDimens.m),
                InkWell(
                  onTap: () {
                    onDismiss();
                    onAction?.call();
                  },
                  child: Text(
                    action,
                    style: typography.input.copyWith(color: colors.textSpecial),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
    );
  }
}

class ErrorMessage extends HookWidget {
  final String content;

  const ErrorMessage({
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    return _MessageView(
      background: AppColors.error100,
      content: Text(
        content,
        style: typography.input.copyWith(color: colors.textSpecial),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _MessageView extends HookWidget {
  final Widget content;
  final Color background;

  const _MessageView({
    required this.content,
    required this.background,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(duration: const Duration(milliseconds: 200));
    final animation = CurvedAnimation(parent: animationController, curve: Curves.easeInOut);

    useEffect(
      () {
        animationController.forward();
      },
      [animationController],
    );

    return SizeTransition(
      sizeFactor: animation,
      axisAlignment: -1,
      axis: Axis.vertical,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimens.s),
        color: background,
        child: content,
      ),
    );
  }
}
