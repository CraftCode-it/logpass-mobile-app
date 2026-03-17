import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final bool isError;
  final bool hasElevation;
  final SystemUiOverlayStyle? systemUiOverlayStyle;

  CustomAppBar({
    this.title = '',
    this.leadingElement,
    this.rightElements = const [],
    this.centerTitle = true,
    this.isBigTitle = false,
    this.leadingWidth,
    this.predefinedBackground,
    this.isError = false,
    this.hasElevation = false,
    this.systemUiOverlayStyle,
  }) : preferredSize = Size.fromHeight(_calculateAppBarHeight(isBigTitle, hasElevation));

  static double _calculateAppBarHeight(bool isBigTitle, bool hasElevation) {
    if (isBigTitle) {
      return hasElevation
          ? kToolbarHeight + AppDimens.m + AppDimens.appBarElevationHeight
          : kToolbarHeight + AppDimens.m;
    } else {
      return hasElevation ? kToolbarHeight + AppDimens.appBarElevationHeight : kToolbarHeight;
    }
  }

  factory CustomAppBar.smallLogo({
    required Color logoColor,
    Widget? trailing,
    bool isError = false,
    bool hasElevation = false,
    SystemUiOverlayStyle? systemUiOverlayStyle,
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
        isError: isError,
        hasElevation: hasElevation,
        systemUiOverlayStyle: systemUiOverlayStyle,
      );

  factory CustomAppBar.smallTitle({
    String? title,
    Widget? leading,
    Widget? trailing,
    bool isError = false,
    bool hasElevation = false,
    SystemUiOverlayStyle? systemUiOverlayStyle,
  }) =>
      CustomAppBar(
        title: title ?? '',
        rightElements: trailing != null ? [trailing] : [],
        leadingElement: leading,
        isError: isError,
        hasElevation: hasElevation,
        systemUiOverlayStyle: systemUiOverlayStyle,
      );

  factory CustomAppBar.bigTitle({
    required String title,
    Widget? trailing,
    bool isError = false,
    bool hasElevation = false,
    SystemUiOverlayStyle? systemUiOverlayStyle,
  }) =>
      CustomAppBar(
        title: title,
        rightElements: trailing != null ? [trailing] : [],
        isBigTitle: true,
        centerTitle: false,
        isError: isError,
        hasElevation: hasElevation,
        systemUiOverlayStyle: systemUiOverlayStyle,
      );

  factory CustomAppBar.smallTitleOnly({
    required String title,
    bool isError = false,
    bool hasElevation = false,
    SystemUiOverlayStyle? systemUiOverlayStyle,
  }) =>
      CustomAppBar(
        title: title,
        isError: isError,
        hasElevation: hasElevation,
        systemUiOverlayStyle: systemUiOverlayStyle,
        rightElements: [],
      );

  @override
  Widget build(BuildContext context) {
    final colors = useAppThemeColors();
    final typography = useAppTypography();

    final foregroundColor = isError ? colors.textSpecial : colors.text;
    rightElements.add(
      const Padding(padding: EdgeInsets.only(right: AppDimens.m)),
    );

    return Column(
      children: [
        AppBar(
          centerTitle: centerTitle,
          systemOverlayStyle: systemUiOverlayStyle,
          backwardsCompatibility: false,
          backgroundColor: isError ? AppColors.error100 : (predefinedBackground ?? colors.background),
          title: Padding(
            padding: EdgeInsets.only(left: isBigTitle ? AppDimens.s : AppDimens.zero),
            child: Text(
              title,
              style: (isBigTitle ? typography.h4 : typography.h8).copyWith(color: foregroundColor),
            ),
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: leadingElement,
          leadingWidth: leadingWidth,
          actions: rightElements,
        ),
        if (hasElevation)
          Container(
            color: colors.inputBorder,
            height: AppDimens.appBarElevationHeight,
          ),
      ],
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
    bool? isError,
    bool? hasElevation,
    SystemUiOverlayStyle? systemUiOverlayStyle,
  }) {
    return CustomAppBar(
      title: title ?? this.title,
      centerTitle: centerTitle ?? this.centerTitle,
      isBigTitle: isBigTitle ?? this.isBigTitle,
      rightElements: rightElements ?? this.rightElements,
      leadingElement: leadingElement ?? this.leadingElement,
      leadingWidth: leadingWidth ?? this.leadingWidth,
      predefinedBackground: predefinedBackground ?? this.predefinedBackground,
      isError: isError ?? this.isError,
      hasElevation: hasElevation ?? this.hasElevation,
      systemUiOverlayStyle: systemUiOverlayStyle ?? this.systemUiOverlayStyle,
    );
  }
}
