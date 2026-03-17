import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logpass_me/presentation/style/app_colors.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  textTheme: GoogleFonts.poppinsTextTheme(),
  colorScheme: ColorScheme.light(surface: AppColors.backgroundDark),
  scaffoldBackgroundColor: AppColors.backgroundDark,
  appBarTheme: AppBarTheme(
    titleTextStyle: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500),
    toolbarTextStyle: GoogleFonts.poppins(),
    backgroundColor: AppColors.backgroundLight,
    elevation: 0,
  ),
  tabBarTheme: TabBarTheme(
    labelStyle: _tabBarSelectedTypography().copyWith(color: AppColors.primary100),
    unselectedLabelStyle: _tabBarUnselectedTypography().copyWith(color: AppColors.primary20),
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  textTheme: GoogleFonts.poppinsTextTheme(),
  colorScheme: ColorScheme.dark(surface: AppColors.backgroundDark),
  scaffoldBackgroundColor: AppColors.backgroundDark,
  appBarTheme: AppBarTheme(
    titleTextStyle: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
    toolbarTextStyle: GoogleFonts.poppins(color: Colors.white),
    backgroundColor: AppColors.backgroundDark,
    elevation: 0,
  ),
  tabBarTheme: TabBarTheme(
    labelStyle: _tabBarSelectedTypography().copyWith(color: AppColors.primary10),
    unselectedLabelStyle: _tabBarUnselectedTypography().copyWith(color: AppColors.primary80),
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
