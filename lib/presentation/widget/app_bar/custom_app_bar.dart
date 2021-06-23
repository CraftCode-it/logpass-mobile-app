import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:logpass_me/presentation/style/app_colors.dart';
import 'package:logpass_me/presentation/style/app_dimens.dart';
import 'package:logpass_me/presentation/style/app_icon.dart';
import 'package:logpass_me/presentation/style/app_typography.dart';

class CustomAppBar extends HookWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final bool centerTitle;
  final bool isBigTitle;
  final List<Widget> rightElements;
  final Widget? leadingElement;
  final double? leadingWidth;
  final Color? predefinedBackground;

  CustomAppBar({
    this.title = '',
    this.leadingElement,
    this.rightElements = const [],
    this.centerTitle = true,
    this.isBigTitle = false,
    this.leadingWidth,
    this.predefinedBackground,
  }) : preferredSize = Size.fromHeight(isBigTitle ? kToolbarHeight + AppDimens.m : kToolbarHeight);

  factory CustomAppBar.smallLogo({
    required Color logoColor,
    Widget? trailing,
  }) =>
      CustomAppBar(
        leadingElement: Padding(
          padding: const EdgeInsets.only(left: AppDimens.l),
          child: SvgPicture.asset(
            AppIcon.logo,
            color: logoColor,
          ),
        ),
        centerTitle: false,
        leadingWidth: AppDimens.appBarLogoWidth,
        rightElements: trailing != null ? [trailing] : [],
      );

  factory CustomAppBar.smallTitle({
    String? title,
    Widget? leading,
    Widget? trailing,
  }) =>
      CustomAppBar(
        title: title ?? '',
        rightElements: trailing != null ? [trailing] : [],
        leadingElement: leading,
      );

  factory CustomAppBar.bigTitle({
    required String title,
    Widget? trailing,
  }) =>
      CustomAppBar(
        title: title,
        rightElements: trailing != null ? [trailing] : [],
        isBigTitle: true,
        centerTitle: false,
      );

  factory CustomAppBar.smallTitleOnly({
    required String title,
  }) =>
      CustomAppBar(
        title: title,
      );

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    return AppBar(
      centerTitle: centerTitle,
      backgroundColor: predefinedBackground ?? colors.background,
      title: Padding(
        padding: EdgeInsets.only(left: isBigTitle ? AppDimens.s : AppDimens.zero),
        child: Text(
          title,
          style: isBigTitle ? typography.h4 : typography.h8,
        ),
      ),
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: leadingElement,
      leadingWidth: leadingWidth,
      actions: rightElements,
    );
  }

  CustomAppBar copyWith({
    String? title,
    bool? centerTitle,
    bool? isBigTitle,
    List<Widget>? rightElements,
    Widget? leadingElement,
    double? leadingWidth,
    Color? predefinedBackground,
  }) {
    return CustomAppBar(
      title: title ?? this.title,
      centerTitle: centerTitle ?? this.centerTitle,
      isBigTitle: isBigTitle ?? this.isBigTitle,
      rightElements: rightElements ?? this.rightElements,
      leadingElement: leadingElement ?? this.leadingElement,
      leadingWidth: leadingWidth ?? this.leadingWidth,
      predefinedBackground: predefinedBackground ?? this.predefinedBackground,
    );
  }
}
