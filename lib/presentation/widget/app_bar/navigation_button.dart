import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';

class NavigationButton extends HookWidget {
  final Function()? customAction;
  final String iconPath;

  const NavigationButton._({
    required this.iconPath,
    this.customAction,
    Key? key,
  }) : super(key: key);

  factory NavigationButton.back({Function()? customAction}) {
    return NavigationButton._(
      iconPath: AppIcon.back,
      customAction: customAction,
    );
  }

  factory NavigationButton.close({Function()? customAction}) {
    return NavigationButton._(
      iconPath: AppIcon.close,
      customAction: customAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();

    return IconButton(
      onPressed: customAction ?? () => AutoRouter.of(context).pop(),
      icon: SvgPicture.asset(
        iconPath,
        color: colors.buttonFill,
      ),
    );
  }
}
