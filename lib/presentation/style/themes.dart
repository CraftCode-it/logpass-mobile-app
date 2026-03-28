import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  textTheme: GoogleFonts.poppinsTextTheme(),
  colorScheme: ColorScheme.light(
    surface: AppColors.backgroundLight,
    onSurface: AppColors.primary100,
  ),
  scaffoldBackgroundColor: AppColors.backgroundLight,
  dialogBackgroundColor: AppColors.secondary,
  appBarTheme: AppBarTheme(
    titleTextStyle: GoogleFonts.poppins(
        fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary100),
    toolbarTextStyle: GoogleFonts.poppins(color: AppColors.primary100),
    backgroundColor: AppColors.backgroundLight,
    foregroundColor: AppColors.primary100,
    iconTheme: const IconThemeData(color: AppColors.primary100),
    elevation: 0,
  ),
  iconTheme: const IconThemeData(color: AppColors.primary100),
  tabBarTheme: TabBarTheme(
    labelStyle: _tabBarSelectedTypography().copyWith(color: AppColors.primary100),
    unselectedLabelStyle: _tabBarUnselectedTypography().copyWith(color: AppColors.primary20),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.primary100,
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
  colorScheme: ColorScheme.dark(
    surface: AppColors.backgroundDark,
    onSurface: AppColors.primary10,
  ),
  scaffoldBackgroundColor: AppColors.backgroundDark,
  dialogBackgroundColor: AppColors.primary96,
  appBarTheme: AppBarTheme(
    titleTextStyle: GoogleFonts.poppins(
        fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary10),
    toolbarTextStyle: GoogleFonts.poppins(color: AppColors.primary10),
    backgroundColor: AppColors.backgroundDark,
    foregroundColor: AppColors.primary10,
    iconTheme: const IconThemeData(color: AppColors.primary10),
    elevation: 0,
  ),
  iconTheme: const IconThemeData(color: AppColors.primary10),
  tabBarTheme: TabBarTheme(
    labelStyle: _tabBarSelectedTypography().copyWith(color: AppColors.primary10),
    unselectedLabelStyle: _tabBarUnselectedTypography().copyWith(color: AppColors.primary80),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.primary10,
  ),
);

TextStyle _tabBarSelectedTypography() {
  return GoogleFonts.poppins(
    fontSize: 16,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
  );
}

TextStyle _tabBarUnselectedTypography() {
  return GoogleFonts.poppins(
    fontSize: 16,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );
}
