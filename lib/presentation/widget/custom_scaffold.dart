import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/widget/app_bar/custom_app_bar.dart';
import 'package:logpass_me/presentation/widget/fullscreen_error.dart';

class CustomScaffold extends HookWidget {
  final Widget body;
  final CustomAppBar appBar;
  final Function()? onTryAgain;
  final Color? customBackgroundColor;
  final bool showErrorPage;

  CustomScaffold({
    required this.body,
    required CustomAppBar appBar,
    this.onTryAgain,
    this.customBackgroundColor,
    this.showErrorPage = false,
    Key? key,
  })  : appBar = showErrorPage ? appBar.copyWith(isError: showErrorPage) : appBar,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();

    return Scaffold(
      backgroundColor: showErrorPage ? AppColors.error100 : (customBackgroundColor ?? colors.background),
      appBar: appBar,
      body: showErrorPage ? FullscreenError(onTryAgain: onTryAgain ?? () {}) : body,
    );
  }
}
