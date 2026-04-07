import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

class NavigationRow extends HookWidget {
  final String? icon;
  final String title;
  final Function() onPressed;

  const NavigationRow._({
    required this.title,
    required this.onPressed,
    this.icon,
    Key? key,
  }) : super(key: key);

  factory NavigationRow.withIcon(String icon, String title, Function() onPressed) {
    return NavigationRow._(title: title, onPressed: onPressed, icon: icon);
  }

  factory NavigationRow.titled(String title, Function() onPressed) {
    return NavigationRow._(title: title, onPressed: onPressed);
  }

  @override
  Widget build(BuildContext context) {
    final typography = useAppTypography();
    final colors = useAppThemeColors();

    final icon = this.icon;

    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.l),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              SvgPicture.asset(
                icon,
                colorFilter: ColorFilter.mode(colors.buttonFill, BlendMode.srcIn),
              ),
              const SizedBox(width: AppDimens.l),
            ],
            Expanded(
              child: Text(
                title,
                style: icon == null ? typography.h9 : typography.h8,
              ),
            ),
            SvgPicture.asset(
              AppIcon.chevronRight,
              colorFilter: ColorFilter.mode(colors.buttonFill, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
